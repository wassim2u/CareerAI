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
                          // Upload file and metadata to the path 'cv_files/CV_filename'
                          final uploadTask = storageRef
                              .child("cv_files/$fileName")
                              .putData(fileBytes!, metadata);
                          final snapshot = await uploadTask;
                          final url = await snapshot.ref.getDownloadURL();
                          debugPrint('here is the download url: $url');


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
          ],
        ),
      );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}


