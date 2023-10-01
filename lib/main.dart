import 'package:flutter/material.dart';
import 'package:steps_counter1/screens/auth.dart';
import 'domain/workout.dart';
import 'screens/home.dart';

void main() {
  runApp(StepsCounterApp());
}

class StepsCounterApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthorizationPage(),
    );
  }
}

