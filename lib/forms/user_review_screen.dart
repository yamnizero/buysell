import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserReviewScreen extends StatelessWidget {
  static const String id = "user-review-screen";

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    var _nameController = TextEditingController();
    var _countryCodeController = TextEditingController(text: '+249');
    var _phoneController = TextEditingController();
    var _emailController = TextEditingController();
    var _addressController = TextEditingController();

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
                      validator: (value){
                        if(value.isEmpty){
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
                      decoration: InputDecoration(labelText: 'Country',helperText: ''),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Mobile number',
                        helperText: 'Enter contact mobile number',
                      ),
                      maxLength: 10,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _phoneController,
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
                  if(value.isNotEmpty && isValid == false){
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
                    suffixIcon: Icon(Icons.arrow_forward_ios,size: 12,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
