import 'package:flutter/material.dart';

class PasswordResetScreen extends StatelessWidget {
  static const String id = "password-reset-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Forgot\npassword?",
              textAlign: TextAlign.center
              ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
          ],
        ),
      ),
    );
  }
}
