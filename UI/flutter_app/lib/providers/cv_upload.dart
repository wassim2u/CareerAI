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




class TodoProvider with ChangeNotifier{

}


class CVSectionPage extends StatelessWidget {
  const CVSectionPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (context) => CVUploadState(),
    child:Padding(
      padding: const EdgeInsets.all(32),
      child: CVUploadArea()
    )
    );
  }
}


class CVUploadArea extends StatefulWidget{
  @override
  State<CVUploadArea> createState() => _CVUploadArea();
}

class CVUploadState extends ChangeNotifier {

  String uploadedCVName = "";
  bool isCVUploaded =  false;
 
  void addCVFile(String cvFileName){
    uploadedCVName = cvFileName;
    isCVUploaded = true;
    notifyListeners();
  }




  // TODO: Remove a CV File
  void removeCVFile(){


    notifyListeners();

  }



}


class _CVUploadArea extends State<CVUploadArea> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CVUploadState>();

    IconData icon;
   
    final ExpansionTileController redactVideoExpansionController = ExpansionTileController();

    
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("To get started, please Upload CV \n (Please remove sensitive data such as Name, Location, Mobile Phone Number, etc.)"),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () async {
                      print("Button Pressed!");
                      // Create a child reference
                      // imagesRef now points to "images"



                        try{ 
                        // TODO: Allow only certain Filetypes : pdf, docx, doc, jpg, jpeg, etc.
                        // TODO: Add authentication access - per User CV Upload for tracking Status.
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

                        if (result != null && result.files.isNotEmpty) {
                          print("File Picked");
                          final fileBytes = result.files.first.bytes;
                          final fileName = result.files.first.name;

             

                          final mimeType = lookupMimeType(fileName); // 'image/jpeg'
                          print(mimeType);

                          // Create the file metadata
                          final metadata = SettableMetadata(contentType: mimeType);
                          

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
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                          );

                          // TOOO: Display the file name downloaded
                          appState.addCVFile(fileName);

                        } else {
                          // User canceled the picker
                          print("User Cancelled Operation, or something went wrong.");
                        }

                        print("File uploaded");
                       
                    }
                    on FirebaseException catch (e){
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
            Container(child: Builder( 
            builder: (context){

              if (appState.isCVUploaded == true) {
                return  Text("File Uploaded: ${appState.uploadedCVName}");
              }
              return Text("");
            })
            ),
            Text("Short Demo of how to Redact (on Mac). Show a GIF on Mac, and show other links for other software."),
            ExpansionTile(
              controller: redactVideoExpansionController,
              title: const Text('Info on how to redact'),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: const    Image(
              image: AssetImage('assets/redact_example_mac.gif'),
              
              fit: BoxFit.scaleDown,
            ),
                ),
                Text("1.Easiest way is to also manually make a copy of your resume where you delete the text data. "),
                Text("2. Another way is to use redact features on PDF software tools. On Mac, you can use Preview to redact. Please find more information online depending on your favourite PDF tool and operating system. ")
              ],
            ),

          ],
        ),
      );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}


