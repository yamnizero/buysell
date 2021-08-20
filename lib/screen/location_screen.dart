import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {

  static const String id = "location-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(
        child: Text("Sign out"),
        onPressed: (){

        },
      ),),
    );
  }
}
