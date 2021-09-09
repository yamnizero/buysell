import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
  static const String id = "user-review-screen";

  @override
  _UserReviewScreenState createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  FirebaseServices _services = FirebaseServices();

  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+249');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();

  @override
  void didChangeDependencies() {
    var _provider = Provider.of<CategoryProvider>(context);
    _provider.getUserDetails();
    setState(() {
      _nameController.text = _provider.userDetails['name'];
      _phoneController.text = _provider.userDetails['mobile'];
      _emailController.text = _provider.userDetails['email'];
      _addressController.text = _provider.userDetails['address'];
    });
    super.didChangeDependencies();
  }

  //first update user data
  Future<void> updateUser(provider,Map<String,dynamic>data,context) {
    return _services.users
        .doc(_services.user.uid)
        .update(data)
        .then((value) {
          //save your new product details
       saveProductsToDb(provider,context);

    },)
        .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<void> saveProductsToDb(CategoryProvider provider,context) {
    return _services.products
        .doc(_services.user.uid)
        .set(
         provider.dataToFirebasestore
    )
        .then((value) {
          //data updated
    },)
        .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          "Review your details",
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
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        radius: 38,
                        child: Icon(
                          CupertinoIcons.person_alt,
                          color: Colors.black,
                          size: 60,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Your Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Contact Details',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _countryCodeController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: 'Country', helperText: ''),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Mobile number',
                          helperText: 'Enter contact mobile number',
                        ),
                        maxLength: 10,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    helperText: 'Enter contact email',
                  ),
                  validator: (value) {
                    //need to check email entered is a valid email or not,i will use package for that "email_validator: ^2.0.1"
                    final bool isValid =
                        EmailValidator.validate(_emailController.text);
                    if (value == null || value.isEmpty) {
                      return "Enter email";
                    }
                    if (value.isNotEmpty && isValid == false) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  enabled: false,
                  minLines: 1,
                  maxLines: 30,
                  controller: _addressController,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      helperText: 'Contact address',
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                onPressed: ()
                {
                  if(_formKey.currentState.validate()){
                    //first need to update user details before saving product data
                    updateUser(_provider,{
                      'contactDetails' :{
                        'name' : _nameController.text,
                        'contactMobile' : _phoneController.text,
                        'contactEmail' : _emailController.text,
                        // //address will update from address screen
                      }

                    }, context);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Enter required fields'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
