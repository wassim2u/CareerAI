import 'package:flutter_app/interviews/behavorial.dart';
import 'package:speech_to_text/speech_to_text.dart';


import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


///////
///
///





// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }


class SpeechRecognition extends StatefulWidget {
  final String initialText;
   const SpeechRecognition({
    super.key,
    required this.initialText,
  });

  @override
  _SpeechRecognitioneState createState() => _SpeechRecognitioneState();
}

class _SpeechRecognitioneState extends State<SpeechRecognition> {
  late String initialTextCopy;

  final Map<String, HighlightedWord> _highlights = {
    'You:': HighlightedWord(
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    )
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _givenPermission = false;
  String _text = 'Press the Microphone button and start speaking. When you finish answering a question, toggle the Microphone button';
  double _confidence = 1.0;
  int _questions_answered = 0;
  
  String _interviewerQuestion = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _interviewerQuestion = widget.initialText;
    _text = "$_interviewerQuestion\n";
    _questions_answered = 0;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
          ),
        ),
      ),
      body: Container( 
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
        child: SingleChildScrollView(
        reverse: true,
          child: TextHighlight(
            text:  _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) { 
          
          print('onStatus: $val');
          if (val == "done" || val == "notListening"){
            _text = _interviewerQuestion;
          }
        
        
        },
        onError: (val) {
          print('onError: $val');    
        }
        
        ,
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            if (_isListening == false){
              _text = _interviewerQuestion;
            }
            else{
              _text = "You: "+ val.recognizedWords;
            }
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      await respondToInterviewer(_text).then((String response){
      setState(() {
           _isListening = false;
           print(response);
            _speech.stop();
           _interviewerQuestion = response;
           _text = _interviewerQuestion;
           _questions_answered+=1; 
          });
      });
    }
  }
}