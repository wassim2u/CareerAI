
import 'package:flutter/material.dart';
import 'package:flutter_app/interviews/behavorial.dart';
import 'package:flutter_app/results/simpleFeedback.dart';
import 'package:flutter_app/widget.dart';


// TODO: Define an abstract class for the different feedbacks
// TODO Remember session , when reloaded return to the interview state.
class FeedbackProcessingPage extends StatelessWidget{

  final String feedbackType;

  const FeedbackProcessingPage({super.key, required this.feedbackType});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (feedbackType){
      case "Quick":
        return QuickResultsPage();
      case "Behavourial":
        return BehavorialMockInterview();
      default:
        return Placeholder();
    }
  }
}