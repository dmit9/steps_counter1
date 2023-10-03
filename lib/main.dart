import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:steps_counter1/screens/steps_page.dart';
import 'package:steps_counter1/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(StepsCounterApp());
}

class StepsCounterApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 130, 129, 150)),
        useMaterial3: true,
      ),
//      home:  const WidgetTree(),
        home: StepsCount(),
    );
  }
}

