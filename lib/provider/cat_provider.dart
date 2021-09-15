import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier {
  FirebaseServices _services = FirebaseServices();

  DocumentSnapshot doc;
  DocumentSnapshot userDetails;
  String selectedCategory;
  String selectedSubCat;
  List<String> urlListImg = [];

  //the data  we are  going to upload firebase
  Map<String, dynamic> dataToFirebasestore = {};

  getCategory(selectedCat) {
    this.selectedCategory = selectedCat;
    notifyListeners();
  }

  getSubCategory(selectedsubCat) {
    this.selectedSubCat = selectedsubCat;
    notifyListeners();
  }

  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }

  getImages(url) {
    this.urlListImg.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirebasestore = data;
    notifyListeners();
  }

  getUserDetails() {
    //we get complete user data
    _services.getUserData().then((value) {
      this.userDetails = value;
      notifyListeners();
    });
  }

  clearData() {
    this.urlListImg = [];
    dataToFirebasestore = {};
    notifyListeners();
  }
}
