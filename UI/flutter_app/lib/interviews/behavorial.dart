// TODO: Create a PDF Report
// TODO: Create a summary web page. Highlight the links

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/interviews/speech.dart';
import 'package:flutter_app/results/behavourialFeedback.dart';
import 'package:flutter_app/widget.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app/interviews/speech.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

//TODO:
// 1. Initialise Interview
// 2. Get SpeechToText user input
// 2. Send user input to GPT model (Python API Call)
// 3. Recieve gpt answer  response
// 4.a) display interviewer transcript.
// 4.b) accumulate result for every answer
// 5.

class BehavourialFeedbackResponseSchema {
  // TODO: int userID
  String? feedbackType;
  String? GPTResponse;

  BehavourialFeedbackResponseSchema({
    this.GPTResponse,
  });

  BehavourialFeedbackResponseSchema.fromJson(dynamic json) {
    GPTResponse = json['GPTResponse'];
    feedbackType = json['feedbackType'];

    // TODO: Check feedback type is always Behavourial
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['GPTResponse'] = GPTResponse;
    map['feedbackType'] = feedbackType;
    return map;
  }
}

class BehavorialMockInterview extends StatelessWidget {
  const BehavorialMockInterview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleAppBar('Behavourial Interview'),
        body: _BehavourialWebViewAvatar());
  }
}

Future<String> intialiseInterview() async {
  int doInitialize = 1;
  String userText = "placeholder";
  var result =
      await http.get(Uri.parse('http://127.0.0.1:5000/guest/behavourial/$doInitialize/$userText'));

  if (result.statusCode == 200) {
    final data = json.decode(result.body) as String;
    return data;
  } else {
    throw Exception("Error to load data for initialising behavourial feedback");
  }
}

Future<String> respondToInterviewer(String userText) async {
  int doNotInitialise = 0;
  var result = await http
      .get(Uri.parse('http://127.0.0.1:5000/guest/behavourial/$doNotInitialise/$userText'));

  if (result.statusCode == 200) {
    final data = json.decode(result.body) as String;
    return data;
  } else {
    throw Exception("Error to load data for behavourial response ");
  }
}



class _BehavourialWebViewAvatar extends StatefulWidget {
  const _BehavourialWebViewAvatar();

  @override
  _WebViewAvatarState createState() => _WebViewAvatarState();
}

class _WebViewAvatarState extends State<_BehavourialWebViewAvatar> {
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse('http://127.0.0.1:3000/'),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
       Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: ClipRRect(
                    // decoration: BoxDecoration(
                    // border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.all(Radius.circular(
                            20.0) //                 <--- border radius here
                        ),
                    // ),
                    child: Container(
                      // alignment:  Alignment.center,
                      child: IFrameCenter(controller: _controller),
                    ))),
            // Text("Insert Text here"),
            // ElevatedButton(onPressed: () {}, child: Text("Restart Demo")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {

                Navigator.push(

                  context, MaterialPageRoute(builder: (context) => BehavourialResultsPage()));

            }, child: Text("Finish Interview")),
      
            SizedBox(height:10),
            Container( width: 700, child: Container(child: Text('Press the Microphone button and start speaking. When you finish answering a question, submit the response by turning off the Microphone button.', softWrap: true))),
            // Container(child: FutureBuilder(
            //     future: intialiseInterview(), 
            //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) { 
                     
            //     if (snapshot.hasError) return Text('Error = ${snapshot.error}');
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return CircularProgressIndicator();
            //     }
          
            //     String? data = snapshot.data as String;
            //     return  Container( width: 700, child: Flexible(child: Text("Interviewer: $data", softWrap: true)));
            //     },
                
            // )
            // )
          ],
        ),
        // Flexible(fit: FlexFit.tight, child: SpeechRecognition()),

          Container(child: FutureBuilder(
                future: intialiseInterview(), 
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) { 
                     
                if (snapshot.hasError) return Text('Error = ${snapshot.error}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                String? interviewerResponse = snapshot.data as String;
                // _text = !interviewerResponse;
                // return  Container( width: 700, child: Flexible(child: Text("Interviewer: $data", softWrap: true)));
                return  Flexible(child: SpeechRecognition(initialText: interviewerResponse));

                },
                
            )
            ),

      ])),
      SizedBox(
        height: 100,
      ),
    ]);
  }
}

class IFrameCenter extends StatelessWidget {
  const IFrameCenter({
    super.key,
    required PlatformWebViewController controller,
  }) : _controller = controller;

  final PlatformWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
            height: 700,
            width: 1000,
            child: PlatformWebViewWidget(
              PlatformWebViewWidgetCreationParams(controller: _controller),
            ).build(context)));
  }
}
