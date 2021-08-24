import 'package:buysell/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

 final LocationData locationData;
   HomeScreen({this.locationData}) ;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String address ="sudan";

  @override
  void initState() {
    getAddress();
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false ,
        title:InkWell(
            onTap: (){},
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top:8,bottom: 8),
              child: Row(

                children:
                [

                  Icon(CupertinoIcons.location_solid,color: Colors.black,size: 18,),
                  Flexible(child: Text(address,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),)),
                  Icon(Icons.keyboard_arrow_down_outlined,color: Colors.black,size: 18,),
                ],
              ),
            ),
          ),
        ),
      ),
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

  Future<String>getAddress()async{
    // From coordinates
    //geocoder: ^0.2.1
    final coordinates = new Coordinates(widget.locationData.latitude,widget.locationData.longitude);
     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      address = first.addressLine;
    });

    return first.addressLine;

  }
}
