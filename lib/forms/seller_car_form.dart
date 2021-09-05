import 'package:buysell/provider/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class SellerCarForm extends StatefulWidget {
  static const String id = "-car-form";

  @override
  _SellerCarFormState createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final _formKey = GlobalKey<FormState>();

  var  _brandController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var _catProvider = Provider.of<CategoryProvider>(context);


    Widget _appBar(){
      return AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text("${_catProvider.selectedCategory} > brands",style: TextStyle(color: Colors.black,fontSize: 14),),
      );
    }


    Widget _brandList(){
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //use this for somany time ,
            _appBar(),
            Expanded(
              child: ListView.builder(
                itemCount: _catProvider.doc['Models'].length,
                  itemBuilder: (BuildContext context,int index){
               return ListTile(
                 onTap: ()
                 {
                   setState(() {
                     _brandController.text =  _catProvider.doc['Models'][index];
                   });
                   Navigator.pop(context);

                 },
                 title: Text(_catProvider.doc['Models'][index] ),
               );
              }),
            ),
          ],
        ),
      );
    }




    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          "Add some details",
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("CAR"),
                InkWell(
                  onTap: (){
                    // lets show list of cars to select instead of manually typing
                   // list from firebase
                    showDialog(context: context, builder: (BuildContext context){
                      return _brandList();
                    });

                  },
                  child: TextFormField(
                    controller: _brandController,
                    enabled: false,
                    decoration:
                        InputDecoration(labelText: 'Brand / Model / Variant'),
                    validator: (value){
                      if(value.isEmpty){
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Next",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                    fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                onPressed: ()
                {
                  validate();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  validate(){
     if(_formKey.currentState.validate()){
       print("validate");
     }
  }
}
