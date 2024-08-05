import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/models/job_feedback.dart';
import 'package:http/http.dart' as http;


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;


import 'package:firebase_core/firebase_core.dart';
import 'package:mime/mime.dart';
import 'package:firebase_auth/firebase_auth.dart';






class InterviewTypeInputPage extends StatelessWidget {

  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;

  const InterviewTypeInputPage({
    super.key,
    required this.processIndex,
    required this.moveToNextOrPrevFormOnClick,
  });




  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (context) => InterviewTypeInputState(),
    child:Padding(
      padding: const EdgeInsets.all(32),
      child: InterviewInputArea(processIndex: processIndex,
              moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick)
    )
    );
  }
}


class InterviewInputArea extends StatefulWidget{

  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  const InterviewInputArea(
      {Key? key,
      required this.processIndex,
      required this.moveToNextOrPrevFormOnClick})
      : super(key: key);



  @override
  State<InterviewInputArea> createState() => _InterviewInputArea();
}

class InterviewTypeInputState extends ChangeNotifier {
  String interviewType = "";

  void setInterviewType(String type){
    interviewType = type;
    notifyListeners();
  }
}


class _InterviewInputArea extends State<InterviewInputArea> {
    late int processIndexCopy;
    late Function moveToNextOrPrevFormOnClickCopy;

    @override
    void initState() {
      super.initState();
      moveToNextOrPrevFormOnClickCopy = widget.moveToNextOrPrevFormOnClick;
      processIndexCopy = widget.processIndex;
    }

  
   
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<InterviewTypeInputState>();

    IconData icon;
  
    
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Select Feedback Type"),
         
            // SizedBox(height: 10),
                Text("Quick"),
            // SizedBox(height: 10),
              Text("Behavourial"),
              Text("Technical - Coming soon"),
          
          
           NextAndBackPairButtons(moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy),

          ],

        ),
      );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}


final _interviewFeedbackTypes = [
  "Simple",
  "Behavourial",
  "Technical"
];




// class typeButton extends


// (int index){
//   return OutlinedButton
// }

//TODO:  Refactor these for all the other files
class NextAndBackPairButtons extends StatelessWidget {
  const NextAndBackPairButtons({
    super.key,
    required this.moveToNextOrPrevFormOnClickCopy,
  });

  final Function moveToNextOrPrevFormOnClickCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BackButton(moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy),
        SizedBox(width:3),
        NextButton(
            moveToNextOrPrevFormOnClickCopy:
                moveToNextOrPrevFormOnClickCopy)
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
    required this.moveToNextOrPrevFormOnClickCopy,
  });

  final Function moveToNextOrPrevFormOnClickCopy;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          moveToNextOrPrevFormOnClickCopy(false);
        },
        child: Text("Back"));
  }
}


class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.moveToNextOrPrevFormOnClickCopy,
  });

  final Function moveToNextOrPrevFormOnClickCopy;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, //change background color of button
          backgroundColor: Color.fromARGB(206, 58, 82, 204), //
          elevation: 10.0,
        ),

        //           ButtonStyle(
        // backgroundColor: WidgetStateProperty.all<Color>(),
        // textStyle:   WidgetStateProperty.all<TextStyle>(TextStyle(color:Colors.white)),
        //           ),
        onPressed: () {

            moveToNextOrPrevFormOnClickCopy(true);
          } 
        ,
        child: Text(
            'Submit',
          ),
        );
  }
}