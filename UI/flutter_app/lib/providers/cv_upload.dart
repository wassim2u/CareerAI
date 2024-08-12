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

class TodoProvider with ChangeNotifier {}

class CVSectionPage extends StatelessWidget {
  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  final Function setUploadedCVLink;
  const CVSectionPage({
    super.key,
    required this.processIndex,
    required this.moveToNextOrPrevFormOnClick,
    required this.setUploadedCVLink,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CVUploadState(),
        child: Padding(
            padding: const EdgeInsets.all(32),
            child: CVUploadArea(
              processIndex: processIndex,
              moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick,
              setUploadedCVLink: setUploadedCVLink,
            )));
  }
}

class CVUploadArea extends StatefulWidget {
  final int processIndex;
  final Function moveToNextOrPrevFormOnClick;
  final Function setUploadedCVLink;
  const CVUploadArea(
      {Key? key,
      required this.processIndex,
      required this.moveToNextOrPrevFormOnClick,
      required this.setUploadedCVLink})
      : super(key: key);

  @override
  State<CVUploadArea> createState() => _CVUploadArea();
}

class CVUploadState extends ChangeNotifier {
  String uploadedCVName = "";
  bool isCVUploaded = false;
  bool nextButtonPressed = false;

  void addCVFile(String cvFileName) {
    uploadedCVName = cvFileName;
    isCVUploaded = true;
    notifyListeners();
  }

  void toggleNextButtonPress() {
    nextButtonPressed = true;
    notifyListeners();
  }

  // TODO: Remove a CV File
  void removeCVFile() {
    notifyListeners();
  }
}

class _CVUploadArea extends State<CVUploadArea> {
  late Function moveToNextOrPrevFormOnClickCopy;
  late int processIndexCopy;
  late Function setUploadedCVLinkCopy;
  @override
  void initState() {
    super.initState();
    moveToNextOrPrevFormOnClickCopy = widget.moveToNextOrPrevFormOnClick;
    processIndexCopy = widget.processIndex;
    setUploadedCVLinkCopy = widget.setUploadedCVLink;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CVUploadState>();

    IconData icon;
    var nextButtonPressed = false;
    final ExpansionTileController redactVideoExpansionController =
        ExpansionTileController();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("To get started, please Upload your CV. \n"),
                   Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () async {
                    print("Button Pressed!");
                    // Create a child reference
                    // imagesRef now points to "images"

                    try {
                      // TODO: Allow only certain Filetypes : pdf, docx, doc, jpg, jpeg, etc.
                      // TODO: Add authentication access - per User CV Upload for tracking Status.
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              type: FileType.any,
                              onFileLoading: (status) => print(status));

                      if (result != null && result.files.isNotEmpty) {
                        print("File Picked");
                        final fileBytes = result.files.first.bytes;
                        final fileName = result.files.first.name;

                        final mimeType =
                            lookupMimeType(fileName); // 'image/jpeg'
                        print(mimeType);

                        // Create the file metadata
                        final metadata =
                            SettableMetadata(contentType: mimeType);

                        // Create a reference to the Firebase Storage bucket
                        final storageRef = FirebaseStorage.instance.ref();
                        print(storageRef);
                        // Upload file and metadata to the path 'cv_files/username/CV_filename'
                        // TODO: Remove "guest", and configure username to be the same as authentication id
                        var filePath = "cv_files/guest/$fileName";

                        final uploadTask = storageRef
                            .child(filePath)
                            .putData(fileBytes!, metadata);

                        final snapshot = await uploadTask;
                        final url = await snapshot.ref.getDownloadURL();
                        debugPrint('here is the download url: $url');
                        setUploadedCVLinkCopy(url);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File Uploaded')),
                        );

                        appState.addCVFile(fileName);
                      } else {
                        // User canceled the picker
                        print(
                            "User Cancelled Operation, or something went wrong.");
                      }

                      print("File uploaded");
                    } on FirebaseException catch (e) {
                      print(e);
                      print("Error in Uploading file");
                    }
                  },
                  child: Text("Upload File")),
              ElevatedButton(
                  onPressed: () async {
                    print("Button Pressed!");
                  },
                  child: Text("Send Hello World")),
            ],
          ),
          Container(child: Builder(builder: (context) {
            if (appState.isCVUploaded == true) {
              return Text("File Uploaded: ${appState.uploadedCVName}");
            } else if (appState.nextButtonPressed == true &&
                appState.isCVUploaded == false) {
              return Text.rich(TextSpan(
                  text: "*Missing required file: Resume/CV",
                  style: TextStyle(color: Colors.red)));
            } else {
              return Text("");
            }
          })),
          ExpansionTile(
            subtitle:   
            Text.rich(TextSpan(children: [
            WidgetSpan(child: Icon(Icons.warning)),
            TextSpan(
              text:
                  "Please remove sensitive data such as Name, Location, Mobile Phone Number, etc.",
              style: TextStyle(fontStyle: FontStyle.italic)
            ),
          ])),

            initiallyExpanded: true,
            controller: redactVideoExpansionController,
            title: const Text('Sensitive Information Notice'),
            children: <Widget>[
              Text(
                  "            1.The easiest way is to manually create a copy of your resume where you delete the sensitive text data.\n        "),
              Text(
                  "2. Another way is to use the redact features on PDF software tools. On Mac, you can use Preview to redact (See the animation GIF).\nPlease find more information online depending on your favorite PDF tool and operating system."),
              
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: const Image(
                  image: AssetImage('assets/redact_example_mac.gif'),
                  fit: BoxFit.scaleDown,
                ),
              ),
                Text(
                  "It is important to remove sensitive information because the Large Language Model may process the information and it may be kept stored. \nDon't enter info that you wouldn't want reviewed or used."),

            ],
          ),
          SizedBox(child: Padding(padding:EdgeInsets.all(10)),),
          NextAndBackPairButtons(appState: appState, moveToNextOrPrevFormOnClickCopy: moveToNextOrPrevFormOnClickCopy),
        ],
      ),
    );
  }
}


//TODO:  Refactor these for all the other files
class NextAndBackPairButtons extends StatelessWidget {
  const NextAndBackPairButtons({
    super.key,
    required this.appState,
    required this.moveToNextOrPrevFormOnClickCopy,
  });

  final CVUploadState appState;
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
            appState: appState,
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
    required this.appState,
    required this.moveToNextOrPrevFormOnClickCopy,
  });

  final CVUploadState appState;
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
          appState.toggleNextButtonPress();

          if (appState.isCVUploaded) {
            moveToNextOrPrevFormOnClickCopy(true);
          } else {}
        },
        child: Text(
            'Next',
          ),
        );
  }
}
