import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  static const colorizeColors = [
    Colors.white,
    Colors.cyan,

  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                color: Colors.white,
              ),
              SizedBox(height: 20,),
              // animated Text
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Buy or Sell',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              ),

            ],
            isRepeatingAnimation: true,
            onTap: () {
              print("Tap Event");
            },
          ),
        ]
      ),
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
    await Future.delayed(Duration(seconds:4));
  }
}
