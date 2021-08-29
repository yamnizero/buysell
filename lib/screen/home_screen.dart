import 'package:buysell/Widgets/custom_appBar.dart';
import 'package:buysell/screen/location_screen.dart';
import 'package:buysell/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String address ="sudan";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
          child: SafeArea(child: CustomAppBar())),
      body: Center(
        child: ElevatedButton(
          child: Text("Sign Out",),
          onPressed: (){
            FirebaseAuth.instance.signOut().then((value){
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            });
          },
        ),
      ),
    );
  }

}
