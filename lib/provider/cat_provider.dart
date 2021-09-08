import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier {

  DocumentSnapshot doc;
  String selectedCategory;
  List<String> urlListImg = [];
  //the data  we are  going to upload firebase
  Map<String,dynamic> dataToFirebasestore = {};


  getCategory(selectedCat)
  {
    this.selectedCategory = selectedCat;
    notifyListeners();
  }

  getCatSnapshot(snapshot)
  {
    this.doc = snapshot;
    notifyListeners();

  }

  getImages(url){
    this.urlListImg.add(url);
    notifyListeners();
  }

  getData(data){
    this.dataToFirebasestore = data;
    notifyListeners();
  }

}