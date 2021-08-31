import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buysell/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'location_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";

  static const colorizeColors = [
    Colors.white,
    Colors.cyan,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontFamily: 'Horizon',
  );

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(
            'assets/images/logo.png',
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          // animated Text
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Buy or Sell',
                textStyle: SplashScreen.colorizeTextStyle,
                colors: SplashScreen.colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
            onTap: () {
              print("Tap Event");
            },
          ),
        ]),
      ),
    );
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(Duration(seconds: 4));
  }
}
