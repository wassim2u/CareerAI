import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/providers/cv_upload.dart';
import 'package:flutter_app/providers/interview_type_input.dart';
import 'package:flutter_app/providers/job_upload.dart';
import 'package:flutter_app/results/simpleFeedback.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timelines/timelines.dart';

import 'widget.dart';

const kTileHeight = 50.0;

const completeColor = Color.fromARGB(255, 195, 205, 255);
const inProgressColor = Color.fromARGB(206, 58, 82, 204);
const todoColor = Color(0xffd1d2d7);


// TODO: Refactor and separate business logic and UI using Bloc
class ProcessTimelinePage extends StatefulWidget {
  @override
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  int _processIndex = 0;

  String? uploadedCVLink;
  String? feedbackType;
  

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }



  


  void moveToNextOrPrevFormOnClick(bool moveForward){
    setState( () {
      if (moveForward){
        if (_processIndex ==  _processes.length -1){
              // TODO: Submit - Move to the results page.
               Navigator.push(

                  context, MaterialPageRoute(builder: (context) => QuickResultsPage(cv_link: "cv_link_placeholder", job_description: "job_description_placeholder",)));
              
          }
          else{
            _processIndex = (_processIndex + 1);
          }
      }
      else{
        // Return back to the previous page (Home)
        if (_processIndex == 0){
          Navigator.pop(context);
        }
        else{
          _processIndex = (_processIndex - 1);    
        }
      }
    });
  }


  

  List listOfIcons = [Icon(Icons.document_scanner_outlined), Icon(Icons.info), Icon(Icons.person)];

  

TimelineTileBuilder buildUXFormBar(BuildContext context) {
    return TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / _processes.length,
        oppositeContentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: listOfIcons[index],
          );
        },
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              _processes[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColor(index),
              ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          var color;
          var child;
          if (index == _processIndex) {
            color = inProgressColor;
            child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          } else if (index < _processIndex) {
            color = completeColor;
            child = Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            );
          } else {
            color = todoColor;
          }

          if (index <= _processIndex) {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(30.0, 30.0),
                  painter: _BezierPainter(
                    color: color,
                    drawStart: index > 0,
                    drawEnd: index < _processIndex,
                  ),
                ),
                DotIndicator(
                  size: 30.0,
                  color: color,
                  child: child,
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                CustomPaint(
                  size: Size(15.0, 15.0),
                  painter: _BezierPainter(
                    color: color,
                    drawEnd: index < _processes.length - 1,
                  ),
                ),
                OutlinedDotIndicator(
                  borderWidth: 4.0,
                  color: color,
                ),
              ],
            );
          }
        },
        connectorBuilder: (_, index, type) {
          if (index > 0) {
            if (index == _processIndex) {
              final prevColor = getColor(index - 1);
              final color = getColor(index);
              List<Color> gradientColors;
              if (type == ConnectorType.start) {
                gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
              } else {
                gradientColors = [
                  prevColor,
                  Color.lerp(prevColor, color, 0.5)!
                ];
              }
              return DecoratedLineConnector(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                ),
              );
            } else {
              return SolidLineConnector(
                color: getColor(index),
              );
            }
          } else {
            return null;
          }
        },
        itemCount: _processes.length,
      );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TitleAppBar('Career Feedback'),
      body: 
      ListView(
        children:[
          SizedBox(
          height: 100 ,
          child: Timeline.tileBuilder(
            shrinkWrap: true,
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 30.0,
            thickness: 5.0,
          ),
        ),
        builder: buildUXFormBar(context),
      )
      ), 
       SizedBox(child: Builder( 
            builder: (context){
            switch (_processes[_processIndex] ) {
              case "Upload CV" :
                return CVSectionPage(processIndex: _processIndex, moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick,);
              case "Job Description":
                return JobUploadPage(processIndex: _processIndex, moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick,);
              case "Feedback Type":
                return InterviewTypeInputPage(processIndex: _processIndex, moveToNextOrPrevFormOnClick: moveToNextOrPrevFormOnClick,);
              default:
                throw AssertionError("Error In Process Timeline Page Navigation");
            }
            
            })
            ), 
        ]
      ),
       
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          // // Validate returns true if the form is valid, or false otherwise.
          // if (_formKey.currentState!.validate()) {
          //   // If the form is valid, display a snackbar. In the real world,
          //   // you'd often call a server or save the information in a database.
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Processing Data')),
          //   );

            setState(() {
            if (_processIndex ==  _processes.length -1){
              // TODO: Submit - Move to the results page.
               Navigator.push(

                  context, MaterialPageRoute(builder: (context) => QuickResultsPage(cv_link: "cv_link_placeholder", job_description: "job_description_placeholder",)));
              
            }
            else{
            _processIndex = (_processIndex + 1);
            }
              });
          // }
        },
        backgroundColor: inProgressColor,
        child: Icon(FontAwesomeIcons.chevronRight),
      ),
    ); 
  }
}

/// hardcoded bezier painter
/// TODO: Bezier curve into package component
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Upload CV',
  'Job Description',
  'Feedback Type',
];