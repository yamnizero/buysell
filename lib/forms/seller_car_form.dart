import 'package:buysell/Widgets/imagePicker_widget.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

class SellerCarForm extends StatefulWidget {
  static const String id = "-car-form";

  @override
  _SellerCarFormState createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final _formKey = GlobalKey<FormState>();

  FirebaseServices _services = FirebaseServices();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _kmController = TextEditingController();
  var _titleController = TextEditingController();
  var _noOfOwnerController = TextEditingController();
  var _descController = TextEditingController();
  var _addressController = TextEditingController();


  //we have maximum data here in this textController , other data provider





  @override
  void initState() {
    _services.getUserData().then((value){
      setState(() {
        _addressController.text = value['address'];
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);



    Widget _appBar(title, fieldValue) {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300),),

        title: Text(
          "$title > $fieldValue",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //use this for somany time ,
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                  itemCount: _catProvider.doc['Models'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _brandController.text =
                              _catProvider.doc['Models'][index];
                        });
                        Navigator.pop(context);
                      },
                      title: Text(_catProvider.doc['Models'][index]),
                    );
                  }),
            ),
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                })
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CAR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      // lets show list of cars to select instead of manually typing
                      // list from firebase
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      controller: _brandController,
                      enabled: false,
                      decoration:
                          InputDecoration(labelText: 'Brand / Model / Variant'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Year',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      prefixText: 'SD ',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Fuel',
                                list: _fuelList,
                                textController: _fuelController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _fuelController,
                      decoration: InputDecoration(
                        labelText: 'Fuel',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Transmission',
                                list: _transmission,
                                textController: _transmissionController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      decoration: InputDecoration(
                        labelText: 'Transmission',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'KM Driven',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'No. of owners',
                                list:_noOfOwner,
                                textController:_noOfOwnerController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      decoration: InputDecoration(
                        labelText: 'No. of owners',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please complete required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Add title',
                      counterText: 'Mention the key features (e.g brand, model)'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descController,
                    maxLength: 4000,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      counterText: 'Include condition, features, reason for selling'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10 ,),
                  Divider(color: Colors.grey,),
                  TextFormField(
                    enabled: false,
                    minLines: 2,
                    maxLines: 4,
                    controller: _addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        counterText: 'Seller address'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please complete required field";
                      }
                      return null;
                    },
                  ),
                  Divider(color: Colors.grey,),
                  //Upload image
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GalleryImage(
                      //need a list of images url
                      imageUrls: _catProvider.urlListImg,
                    ),
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return ImagePickerWidget();
                      });
                    },
                    child: Neumorphic(
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(
                           _catProvider.urlListImg.length>0 ? 'Upload images' :'Upload image'
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80,),
                ],
              ),
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
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  validate(_catProvider);
                  print(_catProvider.dataToFirebasestore);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  validate(CategoryProvider provider) {
    if (_formKey.currentState.validate()) {
      if(provider.urlListImg.isNotEmpty){
        //should have image
        provider.dataToFirebasestore.addAll({
          'category' :provider.selectedCategory,
          'brand' : _brandController.text,
           'year' : _yearController.text,
          'price' : _priceController.text,
          'fuel' : _fuelController.text,
          'transmission' : _transmissionController.text,
          'kmDrive' : _kmController.text,
          'noOfOwners' : _noOfOwnerController.text,
          'title' : _titleController.text,
          'description' : _descController.text,
          'sellerUid': _services.user.uid,
          'images' : provider.urlListImg
        });
        //once saved all data to provider , we need to check user contact details again
        //to confirm all the details  are  there,so we need to go profile screen 
      }else
        {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('image not uploaded'),
          ),
        );
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields'),
        ),
      );
    }

  }

  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric',];
  List<String> _transmission = ['Manually','Automatic'];
  List<String> _noOfOwner = ['1', '2', '3', '4', '4+',];
}
