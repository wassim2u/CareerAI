

// TODO: Create a PDF Report 
// TODO: Create a summary web page. Highlight the links



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/results/webview.dart';
import 'package:flutter_app/widget.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:js/js.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';

class QuickFeedbackResponseSchema { 
  // TODO: int userID
  String? feedbackType;
  String? GPTResponse;

  QuickFeedbackResponseSchema({
    this.GPTResponse,
  });

  QuickFeedbackResponseSchema.fromJson(dynamic json) { 
    GPTResponse = json['GPTResponse'];
    feedbackType = json['feedbackType'];

    // TODO: Check feedback type is always Quick
  }



  Map<String,dynamic> toJson(){
    final map = <String, dynamic>{};
    map['GPTResponse'] = GPTResponse;
    map['feedbackType'] = feedbackType;
    return map;
  }

}




class QuickResultsPage extends StatelessWidget{


  const QuickResultsPage({super.key});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TitleAppBar('Quick Results'),
      body: Row(children: [
        // Text("Results!"),
        SizedBox(height: 10),
        Flexible(
          child: FutureBuilder<String>(
          initialData: "Loading",
           future: quickAIFeedback(), //  Calls the Python REST API

          builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          
          String? data = snapshot.data as String;
          return Center(
            child: SelectionArea(child: Markdown(
                onTapLink: (text, url, title) {
                  try {
                  launchUrl(Uri.parse(url!));
                }
                catch (e){
                    print("Error: $e");
                }
                },
            
    styleSheet: MarkdownStyleSheet(
              h2: const TextStyle(fontSize: 24, color: Colors.lightBlueAccent), 
              code: const TextStyle(fontSize: 14, color: Colors.green),
              
            ),
  data: data))) ?? Text("\n An Error must have occured - Please try submitting for another feedback.");

                    },
          )),
        Text("")
        // TODO: LoadingScreen
      
        
      ],)
    );  
  }
}








Future<String> quickAIFeedback() async {
   // 1. Call API, Passing these arguments
  // 2. Retirve resultong text 
   // 3. Steam the response animation (optional)

// var uri = Uri.https('127.0.0.1:5000', 'api/data');

String userTextPlaceholder="placeholder";
int initialisePlaceholder = 0;

 var result = await http.get(Uri.parse('http://127.0.0.1:5000/guest/quick/$initialisePlaceholder/$userTextPlaceholder'));
// var response = await http.get(uri);

 if (result.statusCode == 200){
  final data = json.decode(result.body) as String;
  return data;
  // return data.map((json) => QuickFeedbackResponseSchema.fromJson(json)).toList();

 }
 else{
  throw Exception("Error to load data for quick feedback");
 }

}




// class BackendBloc extends Cubit<String> {
//   BackendBloc() : super('');

//   Future<void> fetchData() async {
//     final response = await http.get(Uri.parse('http://localhost:5000/api/data'));
//     if (response.statusCode == 200) {
//       emit(response.body);
//     } else {
//       emit('Failed to fetch data');
//     }
//   }
// }
