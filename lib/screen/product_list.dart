import 'package:buysell/Widgets/product_card.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  // static const String id = "product-list-screen";

  final bool proScreen;

  ProductList(this.proScreen);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    var _catProvider = Provider.of<CategoryProvider>(context);

    final _format = NumberFormat('##,##,##0');

    String _kmFormatted(km) {
      var _km = int.parse(km);
      var _formattedkm = _format.format(_km);
      return _formattedkm;
    }

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _catProvider.selectedCategory == 'Cars' ? _services.products
              .orderBy('postedAt').where(
              'category', isEqualTo: _catProvider.selectedCategory).get()
          :_services.products
              .orderBy('postedAt').where(
              'subCat', isEqualTo: _catProvider.selectedSubCat).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140, right: 140),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme
                          .of(context)
                          .primaryColor),
                  backgroundColor: Colors.grey.shade100,
                ),
              );
            }

            if(snapshot.data.docs.length==0){
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Products added\nunder selected category',
                    textAlign: TextAlign.center
                    ,style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proScreen == false)
                  Container(
                      height: 56,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Fresh Recommendation',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2 / 2.6,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.size,
                    itemBuilder: (BuildContext context, int i) {
                      var data = snapshot.data.docs[i];
                      //convert to int because in firestore it is in string
                      var _price = int.parse(data['price']);
                      String _formattedPrice = '\$ ${_format.format(_price)}';

                      return ProductCard(
                          data: data, formattedPrice: _formattedPrice);
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}
