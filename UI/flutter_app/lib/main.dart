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

import 'widget.dart';

Future<void> main() async {
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
      title: 'Ace',
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
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          // mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Wrap(direction: Axis.vertical, children: [
                          Text.rich(TextSpan(children: <InlineSpan>[
                            TextSpan(
                              text: 'In',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "Vision\n",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ])),
                          AutoSizeText('Ace your next ',
                              minFontSize: 50,
                              maxFontSize: 120,
                              style: TextStyle(height: 0.04)),
                          AutoSizeText('interviews.',
                              minFontSize: 50,
                              maxFontSize: 120,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 150,
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
                          AutoSizeText(
                              "Real-time, Personalized Feedback \n Receive instant, AI-generated insights on your interview performance, \n helping you identify strengths and areas for improvement with precision."),
                          AutoSizeText(
                              "Several Interview Options \n Tailor the type of feedback you are looking for, \n whether it is quick resume analysis, behavourial interviews, or technical interviews."),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      ElevatedButton(
                          onPressed: () => _navigateToNextScreen(context),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                TextSpan(text: 'Get Started '),
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(),
                                    child: Icon(Icons.arrow_right_alt_rounded),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ])
                  ],
                )),

            //   Container(
            //   child: Image(image: AssetImage('assets/landing_page.jpeg')),
            // ),
            Image(
              image: AssetImage('assets/landing_page.jpeg'),
              fit: BoxFit.scaleDown,
            )
          ]),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProcessTimelinePage()));
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
