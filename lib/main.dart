import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/screen/authentication/phoneauth_screen.dart';
import 'package:buysell/screen/categories/category_list.dart';
import 'package:buysell/screen/categories/subCategories_screen.dart';
import 'package:buysell/screen/home_screen.dart';
import 'package:buysell/screen/location_screen.dart';
import 'package:buysell/screen/login_screen.dart';
import 'package:buysell/screen/sellItems/seller_category_list.dart';
import 'package:buysell/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forms/seller_car_form.dart';
import 'forms/user_review_screen.dart';
import 'screen/account_screen.dart';
import 'screen/authentication/email_auth_screen.dart';
import 'screen/authentication/email_verification_screen.dart';
import 'screen/authentication/reset_password_screen.dart';
import 'screen/chat_screen.dart';
import 'screen/main_screen.dart';
import 'screen/myAd_screen.dart';
import 'screen/sellItems/seller_subCat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;

  runApp(

    MultiProvider(providers:
    [
      Provider (create: (_) => CategoryProvider()),

    ],
      child: MyApp(),));


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade900,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        //we will add the screen here for easy navigation
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        EmailAuthScreen.id: (context) => EmailAuthScreen(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        PasswordResetScreen.id: (context) => PasswordResetScreen(),
        CategoryListScreen.id: (context) => CategoryListScreen(),
        SubCategoriesList.id: (context) => SubCategoriesList(),
        MainScreen.id: (context) => MainScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        MyAdsScreen.id: (context) => MyAdsScreen(),
        AccountScreen.id: (context) => AccountScreen(),
        SellerCategory.id: (context) => SellerCategory(),
        SellerSubCatList.id: (context) => SellerSubCatList(),
        SellerCarForm.id: (context) => SellerCarForm(),
        UserReviewScreen.id: (context) => UserReviewScreen(),
      },
    );

    // return  FutureBuilder(
    //   future: Init.instance.initialize(),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     // Show splash screen while waiting for app resources to load:
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           theme: ThemeData(
    //             primaryColor: Colors.cyan,
    //           ),
    //           home: SplashScreen());
    //     } else {
    //       // Loading is done, return the app:
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         title: 'Flutter Demo',
    //         theme: ThemeData(
    //           primaryColor: Colors.cyan.shade900,
    //         ),
    //         home: LoginScreen(),
    //         //initial route is not working with our current UI
    //         routes: {
    //           //we will add the screen here for easy navigation
    //           LoginScreen.id :(context) => LoginScreen(),
    //           PhoneAuthScreen.id:(context) => PhoneAuthScreen(),
    //           LocationScreen.id:(context) => LocationScreen(),
    //         },
    //       );
    //     }
    //   },
    // );
  }
}
