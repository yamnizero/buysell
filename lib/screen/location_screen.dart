import 'package:buysell/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {

  static const String id = "location-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/images/location.jpg"),
          SizedBox(height: 20,),
          Text("Where do  want\nto buy/sell products",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold ),
          ),
          SizedBox(height:10,),
          Text("To enjoy all that we have to offer you\nwe need to know where to look for them",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 30,),
          ElevatedButton.icon(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
            onPressed: (){},
          icon: Icon(CupertinoIcons.location_fill),
            label: Text("Around me"),
          ),
        ],
      )
    );
  }
}
