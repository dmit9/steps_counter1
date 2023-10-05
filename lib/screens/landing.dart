import 'package:flutter/material.dart';
import 'package:steps_counter1/screens/auth.dart';
import 'package:steps_counter1/screens/home.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bool isLoggedIn = false;
    return isLoggedIn ? const HomePage() : const AuthorizationPage(); 
      
  }
}