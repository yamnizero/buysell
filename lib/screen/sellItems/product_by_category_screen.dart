import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/screen/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductByCategory extends StatelessWidget {
  static const String id = "product-by-category-screen";

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedSubCat == null
              ? 'Cars'
              : '${_catProvider.selectedCategory} > ${_catProvider.selectedSubCat} ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(child: ProductList(true)),
    );
  }
}
