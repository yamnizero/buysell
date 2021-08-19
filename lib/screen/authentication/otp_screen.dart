

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String number;
  OTPScreen( {this.number}) ;
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
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
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.edit)),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
