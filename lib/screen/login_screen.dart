import 'package:buysell/Widgets/auth_ui.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String id = "login-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Column(

        children: [
          Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset(
                      "assets/images/logo.png",
                    color: Colors.cyan.shade900,
                  ),
                  SizedBox(height: 10,),
                  Text(
                      "Buy or Sell",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                    color: Colors.cyan.shade900,
                    ),
                  ),
                ],
              ),
              )
          ),
          Expanded(
              child: Container(

            child: AuthUi(),
          )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "If you continue, you are accepting\nTerms and Condition and Privacy Policy.",
              textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
