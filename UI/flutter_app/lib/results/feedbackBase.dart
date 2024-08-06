
import 'package:flutter/material.dart';
import 'package:flutter_app/results/simpleFeedback.dart';
import 'package:flutter_app/widget.dart';


// TODO: Define an abstract class for the different feedbacks

class FeedbackProcessingPage extends StatelessWidget{

  final String feedbackType;

  const FeedbackProcessingPage({super.key, required this.feedbackType});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (feedbackType){
      case "Quick":
        return QuickResultsPage();
      default:
        return Placeholder();
    }
  }


  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     appBar: TitleAppBar('Quick Results'),
  //     body: Row(children: [
  //       Text("Results!"),
  //       SizedBox(height: 10),
  //       Center(
  //         child: FutureBuilder<List<QuickFeedbackResponseSchema>>(

  //          future: quickAIFeedback(cv_link, job_description), //  Calls the Python REST API

  //         builder: (_, snapshot) {
  //         if (snapshot.hasError) return Text('Error = ${snapshot.error}');
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return CircularProgressIndicator();
  //         }
  //         String? data = snapshot.data!.first.GPTResponse;
  //           return Text(data ?? "No Feedback");

  //                   },
  //         )),
  //       Text(cv_link),
  //       // TODO: LoadingScreen
      
        
  //     ],)
  //   );  
  // }
  
}