@JS()
library gradient.js;
import 'package:firebase_core/firebase_core.dart';
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
  try{
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
      darkTheme: ThemeData.dark(),
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



class WelcomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Row(children: [
        Text("Ace your next interview."),
        ElevatedButton(onPressed: () => _navigateToNextScreen(context), 
        child: Text("Get Started"))
      ],)
    );  
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProcessTimelinePage()));
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
        onPopInvoked: (bool didPop) async {if (_navigatorKey.currentState?.canPop() ?? false) {
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