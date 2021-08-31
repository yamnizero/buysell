import 'package:buysell/Widgets/banner_widget.dart';
import 'package:buysell/Widgets/category_widget.dart';
import 'package:buysell/Widgets/custom_appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String address ="sudan";



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
          child: SafeArea(child: CustomAppBar())),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: "Find Card, Mobile and many more",
                            labelStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.only(left: 10,right: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.notifications_none),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                //banner
                 BannerWidget(),
                //category
                CategoryWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

}

//category
//car
//job
//properties
//mobile
//furniture
//commercial vehicles
//sports
//service
