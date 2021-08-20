

import 'dart:ffi';

import 'package:buysell/screen/authentication/phoneauth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../location_screen.dart';

class OTPScreen extends StatefulWidget {
  final String number,verId;

  OTPScreen( {this.number,this.verId}) ;


  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  var _text1 = TextEditingController();
  var _text2 = TextEditingController();
  var _text3 = TextEditingController();
  var _text4 = TextEditingController();
  var _text5 = TextEditingController();
  var _text6 = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("Login",style: TextStyle(color: Colors.black),),
        //to remove  back screen
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
         crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            SizedBox(height: 40,),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.cyan.shade200,
              child: Icon(
                CupertinoIcons.person_alt_circle,
                color: Colors.cyan,
                size: 60,
              ),
            ),
            SizedBox(height: 10,),
            Text("Welcome Back ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                     text: "We sent a 6-digit code to ",
                    style: TextStyle(color: Colors.grey,fontSize: 12),
                    children: [
                      TextSpan(
                        text: widget.number,
                        style: TextStyle(fontSize:12,fontWeight: FontWeight.bold,color: Colors.black )
                      ),
                    ]
                  ),
                  ),
                ),
                InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneAuthScreen()));
                    },
                    child: Icon(Icons.edit)),

              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value)
                    {
                      if(value.length ==1)
                        {
                          node.nextFocus();
                        }
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value)
                    {
                      if(value.length ==1)
                      {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text3,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value)
                    {
                      if(value.length ==1)
                      {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text4,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value)
                    {
                      if(value.length ==1)
                      {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text5,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value)
                    {
                      if(value.length ==1)
                      {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text6,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value)
                    {
                      if(value.length ==1)
                      {
                        if(_text1.text.length==1){
                          if(_text2.text.length==1){
                            if(_text3.text.length==1){
                              if(_text4.text.length==1){
                                if(_text5.text.length==1){
                                  //this is  the otp we have received
                                  String _otp = "${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}${_text6.text}";

                                  //Login
                                  phoneCredential(context, _otp);
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )

              ],
            )
          ],
        ),
      ),
    );
  }


  Future<Void>phoneCredential(BuildContext context,String otp)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verId, smsCode: otp);
      //need to otp validated or not
      final User user = ( await _auth.signInWithCredential(credential)).user;

      if(user !=null){
        //Signed in
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }else{
        print("Login Failed");
      }

    }catch(e){
      print(e.toString());
    }
  }
}
