
import 'package:buysell/screen/authentication/email_verification_screen.dart';
import 'package:buysell/screen/location_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuthentication{

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<DocumentSnapshot> getAdminCredential(
      {email, password, isLog, context}) async {
    try {
      DocumentSnapshot _result = await users.doc(email).get();
      if(isLog){
        //direct login
        emailLogin(email,password,context);
      }else{
        //if register
        if(_result.exists){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An account already exists with this email'),
            ),
          );
        }else{
          //register  as new  user
          emailRegister(email,password,context);
        }
      }



      return _result;
    } catch (e) {
      print("validateEmail firebase");
      print(e);
      throw e;
    }



  }

  emailLogin(email, password, context) async  {
    //login with already register email
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user.uid!=null){
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
          ),
        );

      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
          ),
        );
      }
    }
  }

   emailRegister(email, password,context) async {
    //register as a new user
     try {
       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: email,
           password: password
       );
       if(userCredential.user.uid!=null){
         //login success. add user data to firestore
         return users.doc(userCredential.user.uid).set({
           'uid' : userCredential.user.uid,
           'mobile' : null,
           'email' : userCredential.user.email
         }).then((value) async {
           //will send email verification
           await userCredential.user.sendEmailVerification().then((value){
             //screen will move to Email Verification Screen
             Navigator.pushReplacementNamed(context, EmailVerificationScreen.id);
           });

         }).catchError((onError){
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Failed to add user'),
             ),
           );
         });
       }
     } on FirebaseAuthException catch (e) {
       if (e.code == 'weak-password') {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('The password provided is too weak.'),
           ),
         );

       } else if (e.code == 'email-already-in-use') {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('The account already exists for that email.'),
           ),
         );
       } else {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text("error: ${e.code}"),
           ),
         );
       }
     } catch (e) {
       print(e);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Error occurred'),
         ),
       );
     }
   }
}

