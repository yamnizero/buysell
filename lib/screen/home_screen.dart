import 'package:buysell/Widgets/banner_widget.dart';
import 'package:buysell/Widgets/category_widget.dart';
import 'package:buysell/Widgets/custom_appBar.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/screen/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = "sudan";
  @override
  Widget build(BuildContext context) {

    var _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.clearSelectedCat();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SafeArea(child: CustomAppBar())),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           //here
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Column(
                  children: [
                    //banner
                    BannerWidget(),
                    //category
                    CategoryWidget(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            //product list
            ProductList(false),
          ],
        ),
      ),
    );
  }
}

