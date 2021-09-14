import 'package:buysell/provider/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatelessWidget {

  static const String id = "forms-screen";

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('add some details',style: TextStyle(color: Colors.black),),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('${_provider.selectedCategory} > ${_provider.selectedSubCat}'),
          ],
        ),
      ),
    );
  }
}
