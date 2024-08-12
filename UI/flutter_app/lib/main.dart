@JS()
library gradient.js;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:js/js.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/process_timeline.dart';
import 'package:timelines/timelines.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';


import 'widget.dart';

Future<void> main() async {
  WebViewPlatform.instance = WebWebViewPlatform();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      await Firebase.initializeApp();
    }
  }

  runApp(MyApp());
  SemanticsBinding.instance.ensureSemantics();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InVision',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      // darkTheme: ThemeData.dark(),
      onGenerateRoute: (settings) {
        String? path = Uri.tryParse(settings.name!)?.path;
        Widget child;
        switch (path) {
          case '/process_timeline':
            child = ProcessTimelinePage();
            break;
          case '/welcome_page':
            child = WelcomePage();
            break;
          default:
            child = WelcomePage();
        }

        return MaterialPageRoute(builder: (context) => HomePage(child: child));
      },
      initialRoute: '/',
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Flexible(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            // mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                  child: FadeTransitionExample(
                      key: key,
                      widgetToFade: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Wrap(direction: Axis.vertical, children: [
                                Text.rich(TextSpan(children: <InlineSpan>[
                                  TextSpan(
                                    text: 'In|',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "Vision\n",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),

                                TextSpan(
                                  text: "Ace",
                                  style: TextStyle(
                                      fontSize: 50,
                                      height: 1,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),),
                                TextSpan(
                                    text: " your next",
                                    style: TextStyle(
                                        fontSize: 50,
                                        height: 1,
                                        fontWeight: FontWeight.w400),
                                        
                                  ),])),
                                
                                
                                AutoSizeText('interviews.',
                                    minFontSize: 50,
                                    maxFontSize: 120,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 150,
                                        height: 1,
                                        color: Colors.blue)),
                              ])),
                          SizedBox(height: 10),
                          FittedBox(
                            // padding:EdgeInsets.all(1),
                            // alignment: Alignment.bottomCenter,
                            child: Wrap(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: ,
                              direction: Axis.vertical,
                              spacing: 10,

                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            child: Icon(Icons.feedback_outlined,
                                                color: Color.fromARGB(
                                                    206, 58, 82, 204)),
                                          ),
                                        ),
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "  Real-time, Personalized Feedback \n",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            TextSpan(
                                              text:
                                                  "Receive instant, AI-generated insights on your interview performance, \nhelping you identify strengths and areas for improvement with precision.",
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                            // child: Icon(Icons.assessment_outlined, color: Color.fromARGB(206, 58, 82, 204)),
                                            child: Icon(
                                                Icons.video_call_outlined,
                                                color: Color.fromARGB(
                                                    206, 58, 82, 204)),
                                          ),
                                        ),
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "  Several Interview Options \n",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            TextSpan(
                                              text:
                                                  "Tailor the type of feedback you are looking for, \nwhether it is quick resume analysis, behavourial interviews, or technical interviews.",
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  autofocus: false,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                  ),
                                    onPressed: () async {
                                      
                                      if (!await launchUrl(Uri.https('github.com', '/wassim2u/CareerAI'))) {
                                                throw Exception('Could not launch');
                                      }
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!.copyWith(color:Colors.white),
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(),
                                              child: FaIcon(color: Colors.blueGrey, FontAwesomeIcons.github, size:20),
                                            ),
                                          ),
                                          
                                          TextSpan(text: ' Star on Github'),
                                          
                                        ],
                                      ),
                                    )),
                                SizedBox(width:10),
                                ElevatedButton(
                                    onPressed: () =>
                                        _navigateToNextScreen(context),
                                    child: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        children: [
                                          TextSpan(text: 'Get Started '),
                                          WidgetSpan(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(),
                                              child: Icon(Icons
                                                  .arrow_right_alt_rounded),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ]),
                        ],
                      ))),

              //   Container(
              //   child: Image(image: AssetImage('assets/landing_page.jpeg')),
              // ),
              Image(
                image: AssetImage('assets/landing_page.jpeg'),
                fit: BoxFit.scaleDown,
              )
            ]),
      ),
      FadeTransitionExample(widgetToFade:BottomBannerWelcomePage()),
    ]));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProcessTimelinePage()));
  }
}

class BottomBannerWelcomePage extends StatelessWidget {
  const BottomBannerWelcomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(left: 22.0),
        child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Powered by ",
                  textAlign: TextAlign.center,
                ),
                Image(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/Gemini-Logo.png')),
              ],
            ))));
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.maybePop();
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => widget.child,
              ),
            ),
          ),
          // if (kIsWeb) WebAlert()
        ],
      ),
    );
  }
}
