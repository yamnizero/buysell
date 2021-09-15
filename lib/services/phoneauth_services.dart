

import 'package:buysell/screen/authentication/otp_screen.dart';
import 'package:buysell/screen/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user =FirebaseAuth.instance.currentUser;

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(context,uid) async{

    final QuerySnapshot result =await users.where('uid',isEqualTo:uid).get();
    List<DocumentSnapshot> document =result.docs;

    if(document.length>0){
      //user date exists
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    }else{
      //does not exists
      return users.doc(user.uid)
          .set({
        'uid': user.uid,
        'mobile': user.phoneNumber,
        'email': user.email ,
        'name' : null,
        'address' : null,
      })
          .then((value) {
        //after add data to firebase then will go to next screen
        //if you pushReplacementNamed or push replacement , then u cant go back previous screen
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      })
          .catchError((error) => print("Failed to add user: $error"));
    }


  }


  Future<void> verifyPhoneNumber(BuildContext context,number) async {
    final PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential credential) async {
      //if we user real number , sometime in android device this will work that
      //System will login automatically
      //lets try once
        await auth.signInWithCredential(credential);
    };


    final PhoneVerificationFailed verificationFailed =  (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print("The error is ${e.code}");
    };


    final PhoneCodeSent codeSent =  (String verId, int resendToken)async {
      //if OTP send now new screen  to should open to enter OTP.
     Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(number: number,verId: verId,)));
    };


    try{
      auth.verifyPhoneNumber(phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verificationId){
         print(verificationId);
          });
    }catch(e){
      print("Error ${e.toString()}");
    }

  }

}


// if u fave any error  with real number add sha256 in firebase