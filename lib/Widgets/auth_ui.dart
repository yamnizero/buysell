import 'package:buysell/screen/authentication/email_auth_screen.dart';
import 'package:buysell/screen/authentication/google_auth.dart';
import 'package:buysell/screen/authentication/phoneauth_screen.dart';
import 'package:buysell/services/phoneauth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthUi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220,
            child: ElevatedButton(
                style:ElevatedButton.styleFrom(
               primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)
                  ),
                ),
                onPressed: ()
                {
                  Navigator.pushNamed(context, PhoneAuthScreen.id);
                },
                child: Row(
              children: [
                Icon(Icons.phone_android,color: Colors.black,),
                SizedBox(width: 8,),
                Text("Continue with phone",style: TextStyle(color: Colors.black),),
              ],
            )),
          ),
          SignInButton(
              Buttons.Google,
              text:"Continue with Google",
              onPressed: () async{
                User user = await GoogleAuthentication.signInWithGoogle(context: context);
                if(user!=null){
                  //login success
                 PhoneAuthServices _authentication = PhoneAuthServices();
                 _authentication.addUser(context, user.uid);
                }
              }),
          SignInButton(
              Buttons.FacebookNew,
              text:"Continue with Facebook",
              onPressed: (){}),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("OR",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, EmailAuthScreen.id);
            },
            child: Container(
              child: Text(
                "Login with Email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color:Colors.white))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
