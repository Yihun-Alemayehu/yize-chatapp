import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/auth/auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash:const Column(
        children: [
          //Images.asset('assets/fast.png'),
          Text(
            'Yize chatApp',
             style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 226, 111, 3),
             ),
             ),
        ],
      ), 
      backgroundColor: Colors.black,
      nextScreen: const AuthPage(),
      );
  }
}