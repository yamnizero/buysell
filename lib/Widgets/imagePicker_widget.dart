import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File _image;
  bool _uploading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("no image selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    Future<String> uploadFile() async {
      //here error
      File file = File(_image.path);
      String imageName = 'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String downloadUrl;
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl = await FirebaseStorage.instance
            .ref(imageName)
            .getDownloadURL();
        if(downloadUrl!=null){
          setState(() {
            _image=null;
            print(downloadUrl);
          });
        }
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cancelled'),
          ),
        );
      }
      return downloadUrl;

    }



    return Dialog(
      child: Column(
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Upload images",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if(_image!=null)
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: ()
                        {
                          setState(() {
                            _image=null;
                            uploadFile().then((url) {
                              if(url!=null){
                               setState(() {
                                 _uploading =false;
                               });
                              }
                            });
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                          child: _image == null
                              ? Icon(
                                  CupertinoIcons.photo_on_rectangle,
                                  color: Colors.grey,
                                )
                              : Image.file(_image)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if(_image!=null)
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        style: NeumorphicStyle(color: Colors.green),
                        onPressed: ()
                        {
                          setState(() {
                            _uploading =true;

                          });
                        },
                        child: Text(
                          "save",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: NeumorphicButton(
                        style: NeumorphicStyle(color: Colors.red),
                        onPressed: () {},
                        child: Text(
                          "cancel",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImage,
                        style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor),
                        child: Text(
                          'Upload image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                if(_uploading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
