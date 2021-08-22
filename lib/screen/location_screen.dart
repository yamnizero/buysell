import 'package:buysell/screen/home_screen.dart';
import 'package:buysell/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {

  static const String id = "location-screen";

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {

    bool _loading =false;
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    Future<LocationData>getLocation() async {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }


        _locationData = await location.getLocation();


      return _locationData;
    }



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
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: _loading ?
                  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),))
                  :ElevatedButton.icon(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
                  icon: Icon(CupertinoIcons.location_fill),
                    label: Padding(
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      child: Text(
                          "Around me",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: (){
                     setState(() {
                       _loading=true;
                     });
                      getLocation().then((value){
                        if(value!=null){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen(
                              locationData: _locationData,
                            ),
                          ),
                          );
                        }
                      });
                    },
                  ),
                ),

              ],
            ),
          ),
          TextButton(
              onPressed: (){},
              child: Text(
                  "set location manually",
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black,decoration: TextDecoration.underline),
              )
          ),
        ],
      ),
    );
  }
}
