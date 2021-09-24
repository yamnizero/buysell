import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/screen/categories/category_list.dart';
import 'package:buysell/screen/categories/subCategories_screen.dart';
import 'package:buysell/screen/sellItems/product_by_category_screen.dart';
import 'package:buysell/screen/sellItems/seller_subCat.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    var _catProvider = Provider.of<CategoryProvider>(context);


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              _services.categories.orderBy('sortId', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Categories")),
                      TextButton(
                        onPressed: () {
                          //list of categories
                          Navigator.pushNamed(context, CategoryListScreen.id);
                        },
                        child: Row(
                          children: [
                            Text(
                              "See all",
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var doc = snapshot.data.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              _catProvider.getCategory(doc['catName']);
                              _catProvider.getCatSnapshot(doc);
                              if (doc['subCat'] == null) {
                                _catProvider.getSubCategory(null);
                                //here now  need  to sue provider
                                return Navigator.pushNamed(context, ProductByCategory.id);
                              }
                              Navigator.pushNamed(context, SubCategoriesList.id,
                                  arguments: doc);
                            },
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Column(
                                children: [
                                  Image.network(doc['image']),
                                  Flexible(
                                    child: Text(
                                      doc['catName'].toUpperCase(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
