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

final interviewFeedbackTypes = ["Quick", "Behavourial", "Technical"];

final List<Widget> _interviewFeedbackTypeTextWidgets = <Widget>[
  Text.rich(TextSpan(style: TextStyle(color: Colors.black), children: [
    WidgetSpan(child: Icon(Icons.bolt_outlined)),
    TextSpan(
        text: " ${interviewFeedbackTypes[0]}\n",
        style: TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
        text:
            "Rapid assessment of job-resume fit. Identifies key strengths, weaknesses, and overall suitability.")
  ])),
  Text.rich(TextSpan(style: TextStyle(color: Colors.black), children: [
    WidgetSpan(child: Icon(Icons.corporate_fare_outlined)),
    TextSpan(
        text: " ${interviewFeedbackTypes[1]}\n",
        style: TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
      text:
          "Simulated behavioral interview assessing cultural fit and behavioral competencies. Offers feedback on communication skills, problem-solving, and decision-making abilities.\n",
    ),
    WidgetSpan(child: Image( height: 200, image: AssetImage("assets/preview/behavourial_google_ceo_avatar.png"), fit: BoxFit.scaleDown,
)),
  ])),
  Text.rich(TextSpan(style: TextStyle(color: Colors.grey), children: [
    WidgetSpan(child: Icon(Icons.code_sharp)),
    TextSpan(text: " ${interviewFeedbackTypes[2]} (Coming Soon)\n"),
    TextSpan(
        text:
            "Simulated coding challenge evaluating problem-solving, algorithm design, communication (i.e asking clarifying questions), and coding proficiency.\n",
        style: TextStyle(color: Colors.grey)),
    WidgetSpan(child: Image( height: 200, image: AssetImage("assets/preview/technical_preview.png"), fit: BoxFit.scaleDown,))

  ])),
];

class InterviewTypeInputPage extends StatelessWidget {
  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  final Function setFeedbackType;

  const InterviewTypeInputPage({
    super.key,
    required this.processIndex,
    required this.moveToNextOrPrevFormOnClick,
    required this.setFeedbackType
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => InterviewTypeInputState(),
        child: Padding(
            padding: const EdgeInsets.all(32),
            child: InterviewInputArea(
                processIndex: processIndex,
                moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick,
                setFeedbackType: setFeedbackType)));
  }
}

class InterviewInputArea extends StatefulWidget {
  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  final Function setFeedbackType;
  const InterviewInputArea(
      {Key? key,
      required this.processIndex,
      required this.moveToNextOrPrevFormOnClick,
      required this.setFeedbackType,})
      : super(key: key);

  @override
  State<InterviewInputArea> createState() => _InterviewInputArea();
}

class InterviewTypeInputState extends ChangeNotifier {
  String interviewType = "";

  void setInterviewType(String type) {
    interviewType = type;
    notifyListeners();
  }
}

class _InterviewInputArea extends State<InterviewInputArea> {
  late int processIndexCopy;
  late Function moveToNextOrPrevFormOnClickCopy;
  late Function setFeedbackTypeCopy;

  @override
  void initState() {
    super.initState();
    moveToNextOrPrevFormOnClickCopy = widget.moveToNextOrPrevFormOnClick;
    processIndexCopy = widget.processIndex;
    setFeedbackTypeCopy = widget.setFeedbackType;
  }

  final List<bool> selectedFeedback = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<InterviewTypeInputState>();

    IconData icon;
    final ThemeData theme = Theme.of(context);

    return Container(
 
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // ToggleButtons with a single selection.
          Text('Select Feedback Type', style:  Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          ToggleButtons(
              direction: Axis.vertical,
              renderBorder: false,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < selectedFeedback.length; i++) {
                    selectedFeedback[i] = i == index;
                  }
                  setFeedbackTypeCopy(interviewFeedbackTypes[index]);
                  
                });
              },
              // borderRadius: const BorderRadius.all(Radius.circular(8)),
              // selectedBorderColor: Colors.blue,
              // selectedColor: Colors.white,
              fillColor: Colors.white,
              color: Colors.white,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 40.0,
              ),
              isSelected: selectedFeedback,
              children: List<Widget>.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            
                            border: Border.all(width:2, color: selectedFeedback[index]? Color.fromARGB(255, 0, 132, 248):Colors.black38),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(20),
                          // width: 160,
                          // height: 70,
                          alignment: Alignment.topLeft,
                          child: 
                            _interviewFeedbackTypeTextWidgets[index],
                          
                        ),
                      ))),
        
        
        

         NextAndBackPairButtons(moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy),

        ],
      
      
      ),
    );
  }
}

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
        BackButton(
            moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy),
        SizedBox(width: 3),
        NextButton(
            moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy)
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
      },
      child: Text(
        'Submit',
      ),
    );
  }
}
