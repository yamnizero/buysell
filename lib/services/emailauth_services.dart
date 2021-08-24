
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmailAuthentication{

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<DocumentSnapshot> getAdminCredential(
      {email, password, isLog, context}) async {
    DocumentSnapshot _result = await users.doc(email).get();


    if(isLog){
      //direct login
      emailLogin(email,password);
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
        emailRegister(email,password);
      }
    }



    return _result;
  }

  emailLogin(email, password) {
    //login with already register email
  }

   emailRegister(email, password) {
    //register as a new user
   }
}

