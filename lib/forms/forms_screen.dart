import 'package:buysell/Widgets/imagePicker_widget.dart';
import 'package:buysell/forms/from_class.dart';
import 'package:buysell/forms/user_review_screen.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  static const String id = "forms-screen";

  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {

  FormClass _formClass = FormClass();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();

  var _brandsText = TextEditingController();
  var _typeText = TextEditingController();
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _bedrooms = TextEditingController();
  var _bathrooms = TextEditingController();
  var _furnishing = TextEditingController();
  var _consStatus = TextEditingController();
  var _buildingSqft = TextEditingController();
  var _carpetSqft = TextEditingController();
  var _totalFloors = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showBrandDialog(list,_textController){
      return showDialog(context: context, builder: (BuildContext context){
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              _formClass.appBar(_provider),
              Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context,int i){
                  return ListTile(
                    onTap: (){
                      setState(() {
                        _textController.text = list[i];
                      });
                      Navigator.pop(context);
                    },
                    title:Text(list[i]),
                  );
                }),
              ),
            ],
          ),
        );
      });
    }
    showFormDialog(list,_textController){
      return showDialog(context: context, builder: (BuildContext context){
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
            [
              _formClass.appBar(_provider),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context,int i){
                return ListTile(
                  onTap: (){
                    setState(() {
                      _textController.text = list[i];
                    });
                    Navigator.pop(context);
                  },
                  title:Text(list[i]),
                );
              }),
            ],
          ),
        );
      });
    }
    validate(CategoryProvider provider) {
      if (_formKey.currentState.validate()) {
        if (provider.urlListImg.isNotEmpty) {
          //should have image
          provider.dataToFirebasestore.addAll({
            'category': provider.selectedCategory,
            'subCat': provider.selectedSubCat,
            'brand': _brandsText.text,
            'type': _typeText.text,
            'bedrooms': _bedrooms.text,
            'bathrooms': _bathrooms.text,
            'furnishing': _furnishing.text,
            'ConstructionStatus': _consStatus.text,
            'buildingSqft': _buildingSqft.text,
            'carpetSqft': _carpetSqft.text,
            'totalFloors': _totalFloors.text,
            'price': _priceController.text,
            'title': _titleController.text,
            'description': _descController.text,
            'sellerUid': _services.user.uid,
            'images': provider.urlListImg,
            'postedAt' : DateTime.now().microsecondsSinceEpoch,
            'favourites':[]
          });
          //once saved all data to provider , we need to check user contact details again
          //to confirm all the details  are  there,so we need to go profile screen
          Navigator.pushNamed(context, UserReviewScreen.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('image not uploaded'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please complete required fields'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('${_provider.selectedCategory} > ${_provider.selectedSubCat}'),
                //this brands should show only for mobile
                if(_provider.selectedSubCat == 'Mobiles Android')
                InkWell(
                  onTap: ()
                  {
                    showBrandDialog(_provider.doc['brands'],_brandsText);
                  },
                  child: TextFormField(
                    controller: _brandsText,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Brands',
                    ),
                  ),
                ),
                if(_provider.selectedSubCat == 'Accessories' ||
                    _provider.selectedSubCat == 'Tablets' ||
                    _provider.selectedSubCat == 'sell : House & Apartments' ||
                    _provider.selectedSubCat == 'Rent :House & Apartments')
                  InkWell(
                  onTap: ()
                  {
                    if(_provider.selectedSubCat == 'Tablets'){
                      return showFormDialog(_formClass.tabType, _typeText);
                    }
                    if(_provider.selectedSubCat == 'sell : House & Apartments' ||  _provider.selectedSubCat == 'Rent :House & Apartments'){
                      return showFormDialog(_formClass.apartmentType, _typeText);
                    }
                    showFormDialog(_formClass.accessories,_typeText);
                  },
                  child: TextFormField(
                    controller: _typeText,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Type',
                    ),
                  ),
                ),
                if( _provider.selectedSubCat == 'sell : House & Apartments' || _provider.selectedSubCat == 'Rent :House & Apartments' )
                Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: ()
                        {
                          showFormDialog(_formClass.number,_bedrooms);
                        },
                        child: TextFormField(
                          controller: _bedrooms,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Bedrooms',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: ()
                        {
                          showFormDialog(_formClass.number,_bathrooms);
                        },
                        child: TextFormField(
                          controller: _bathrooms,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Bathrooms',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: ()
                        {
                          showFormDialog(_formClass.furnishing,_furnishing);
                        },
                        child: TextFormField(
                          controller: _furnishing,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Furnishing',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: ()
                        {
                          showFormDialog(_formClass.consStatus,_consStatus);
                        },
                        child: TextFormField(
                          controller: _consStatus,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Construction Status',
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _buildingSqft,
                        decoration: InputDecoration(
                          labelText: 'Building SQFT',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _carpetSqft,
                        decoration: InputDecoration(
                          labelText: 'Carpet SQFT',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _totalFloors,
                        decoration: InputDecoration(
                          labelText: 'Total Floors',
                        ),
                      ),
                    ],
                  ),
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
                    if(value.length<5){
                      //price should at least above 10,000
                      return 'Required minimum price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                      labelText: 'Add title',
                      helperText:
                      'Mention the key features (e.g brand, model)'),
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
                  minLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      helperText:
                      'Include condition, features, reason for selling'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please complete required field";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.grey,
                ),
                //Upload image
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _provider.urlListImg.length == 0
                      ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "No image selected",
                      textAlign: TextAlign.center,
                    ),
                  )
                      : GalleryImage(
                    //need a list of images url
                    imageUrls: _provider.urlListImg,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ImagePickerWidget();
                        });
                  },
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Theme.of(context).primaryColor,
                        )),
                    child: Container(
                      height: 40,
                      child: Center(
                        child: Text(_provider.urlListImg.length > 0
                            ? 'Upload more images'
                            : 'Upload image'),
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
                  validate(_provider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


}
