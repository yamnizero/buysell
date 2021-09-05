import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier
{

  DocumentSnapshot doc;
  String selectedCategory;

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

}