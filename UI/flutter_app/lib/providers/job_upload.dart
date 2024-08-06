import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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


import 'package:form_field_validator/form_field_validator.dart';

import 'package:firebase_core/firebase_core.dart';




class JobUploadPage extends StatelessWidget {
  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  final Function getUploadedCVLink;
  const JobUploadPage({
    super.key,
    required this.processIndex,
    required this.moveToNextOrPrevFormOnClick,
    required this.getUploadedCVLink,
  });


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (context) => JobUploadState(),
    child:Padding(
      padding: const EdgeInsets.all(32),
      child: JobUploadArea(  processIndex: processIndex,
              moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick,
              getUploadedCVLink: getUploadedCVLink)
    )
    );
  }
}


class JobUploadArea extends StatefulWidget{

  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  final Function getUploadedCVLink;
  const JobUploadArea(
      {Key? key,
      required this.processIndex,
      required this.moveToNextOrPrevFormOnClick,
      required this.getUploadedCVLink})
      : super(key: key);

  @override
  State<JobUploadArea> createState() => _JobUploadArea();
}

class JobUploadState extends ChangeNotifier {

  bool isJobDescriptionUploaded =  false;
  String uploadedJobDescription = "";
 
  void jobUploadSuccessfullyToggle(String jobDescription){
    isJobDescriptionUploaded = true;
    uploadedJobDescription = jobDescription;
    notifyListeners();
  }

  bool nextButtonPressed = false;

  void toggleNextButtonPress(){
    nextButtonPressed = true;
    notifyListeners();
  }



}


// Defining a custom Form widget to input the job description provided by user.
class JobDescriptionForm extends StatefulWidget{
  final Function getUploadedCVLinkCopy;
  const JobDescriptionForm(
      {Key? key,
      required this.getUploadedCVLinkCopy})
      : super(key: key);
  @override
  State<JobDescriptionForm> createState() => _JobDescriptionFormState();

}

// The class holds the job description data related to the form
class _JobDescriptionFormState extends State<JobDescriptionForm>{
// Create a text controller and use it to retrieve the current value of the TextField
  

  final jobController = TextEditingController();
  // late FocusNode jobDescriptionFocusNode;
  late Function getUploadedCVLinkCopy;
  @override
  void initState(){
    getUploadedCVLinkCopy = widget.getUploadedCVLinkCopy;

    super.initState();
    // jobDescriptionFocusNode = FocusNode();
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override 
  void dispose() {

      
      // Clean up the TextEditingController & FocusNode when the widget is disposed.
      // jobDescriptionFocusNode.dispose();
      jobController.dispose();
      super.dispose();
  }


  @override
  Widget build(BuildContext context){
      var appState = context.watch<JobUploadState>();
        
        return Form(
        
        key:_formKey,
        child:
        TextFormField(
                      controller: jobController,
                      // focusNode:  jobDescriptionFocusNode,
                      validator: RequiredValidator(errorText: "*Required"),
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.file_copy_outlined),
                        border: OutlineInputBorder(),
                        hintText: 'Please provide the job link here, or enter the job description manually.',
                        suffixIcon: Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            child: Text("Upload"),
                            onPressed: () async {

                              
                         
                              var db = FirebaseFirestore.instance;

                        
                              if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Processing Data')),
                                    );

                                    String textToUpload = jobController.text;
                                    print(textToUpload);
                                // TODO: Replace "guest" with userID after authentication. 
                                  String uploadedCV = widget.getUploadedCVLinkCopy();
                                  print("job_description: $textToUpload");
                                  print("cv_link: $uploadedCV");
                                  print("---");

                                  FirebaseFirestore.instance.collection("job_descriptions").doc("guest").set(
                                      {
                                        "job_description": textToUpload,
                                        "cv_link": uploadedCV,
                                      }
                                    ).onError((e, _) => print("Error uploading job description on document reference named: $e"));
                                
                                
                                // Quick check!
                                // TODO: Replace "guest" with userID after authentication. 
                                final docRef = db.collection("job_descriptions").doc("guest");
                                docRef.get().then(
                                    (res) => print("Data uploaded: $res"),
                                    onError: (e) => print("Error retrieving job description from referenced document: $e"),
                                  );
                                                                    
                                      
                                // If the data is uploaded, display a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Data Uploaded!')),
                                );
                                
                                appState.jobUploadSuccessfullyToggle(textToUpload);
                        
                            }              
                              
                            },
                          )
                        )
                      ),
            )
  ) ;
  }
}




class _JobUploadArea extends State<JobUploadArea> {

    late int processIndexCopy;
    late Function moveToNextOrPrevFormOnClickCopy;
    late Function getUploadedCVLinkCopy;
  @override
  void initState() {

    moveToNextOrPrevFormOnClickCopy = widget.moveToNextOrPrevFormOnClick;
    processIndexCopy = widget.processIndex;
    getUploadedCVLinkCopy = widget.getUploadedCVLink;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<JobUploadState>();

    IconData icon;
    String uploadedCVLinkCopy = getUploadedCVLinkCopy();
    print("overhere");
    print(uploadedCVLinkCopy);
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: JobDescriptionForm(getUploadedCVLinkCopy:getUploadedCVLinkCopy),
                  ),
              ),
              ],
              
            ),
          Container(child: Builder(builder: (context) {
            if (appState.nextButtonPressed == true &&
                appState.isJobDescriptionUploaded == false) {
              return Text.rich(TextSpan(
                  text: "*Missing required field: Job Description / Link",
                  style: TextStyle(color: Colors.red)));
            } else {
              return Text("");
            }
          })),  

       NextAndBackPairButtons(moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy),

          
          ],
        ),
        
        
      );
  }
}





//TODO:  Refactor these for all the other process timeline files - Very similar elements
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
    var appState = context.watch<JobUploadState>();

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
          appState.toggleNextButtonPress();

          if (appState.isJobDescriptionUploaded)
            {moveToNextOrPrevFormOnClickCopy(true);};
          } 
        ,
        child: Text(
            'Next',
          ),
        );
  }
}
