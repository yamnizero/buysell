import 'package:buysell/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class FirebaseServices{


  User user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');


  Future<void> updateUser(Map<String,dynamic>data,context) {
    return users
        .doc(user.uid)
        .update(data)
        .then((value) {
      Navigator.pushNamed(context, HomeScreen.id);
    })
        .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }



  Future<String>getAddress(lat,long)async{
    // From coordinates
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
   var first = addresses.first;

   return first.addressLine;

  }
}