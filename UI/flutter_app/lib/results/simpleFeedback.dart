

// TODO: Create a PDF Report 
// TODO: Create a summary web page. Highlight the links



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/widget.dart';
import 'package:http/http.dart' as http;


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
        Text("Results!"),
        SizedBox(height: 10),
        Center(
          child: FutureBuilder<List<QuickFeedbackResponseSchema>>(

           future: quickAIFeedback(), //  Calls the Python REST API

          builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          String? data = snapshot.data!.first.GPTResponse;
            return Text(data ?? "No Feedback");

                    },
          )),
        Text(""),
        // TODO: LoadingScreen
      
        
      ],)
    );  
  }
}



Future<List<QuickFeedbackResponseSchema>> quickAIFeedback() async {
   // 1. Call API, Passing these arguments
  // 2. Retirve resultong text 
   // 3. Steam the response animation (optional)

 var result = await http.get(Uri.parse('http://localhost:5000/api/data'));

 if (result.statusCode == 200){
  final data = json.decode(result.body) as List<dynamic>;
  return data.map((json) => QuickFeedbackResponseSchema.fromJson(json)).toList();

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
