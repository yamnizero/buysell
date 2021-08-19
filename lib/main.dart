import 'package:buysell/screen/authentication/phoneauth_screen.dart';
import 'package:buysell/screen/login_screen.dart';
import 'package:buysell/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.cyan,
              ),
              home: SplashScreen());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.cyan.shade900,
            ),
            home: LoginScreen(),
            routes: {
              LoginScreen.id :(context) => LoginScreen(),
              PhoneAuthScreen.id:(context) => PhoneAuthScreen(),
            },
          );
        }
      },
    );
  }
}
