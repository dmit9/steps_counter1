import 'package:flutter/material.dart';
import 'package:steps_counter1/auth.dart';
import 'package:steps_counter1/screens/home_page.dart';
//import 'package:steps_counter1/screens/home.dart';
import 'package:steps_counter1/screens/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return HomePage(); 
        } else {
          return const LoginPage();
        }
      },
    );
  }
}