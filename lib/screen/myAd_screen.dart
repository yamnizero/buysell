import 'package:buysell/Widgets/product_card.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAdsScreen extends StatelessWidget {
  static const String id = "MyAds-screen";

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    final _format = NumberFormat('##,##,##0');

    String _kmFormatted(km){
      var _km =int.parse(km);
      var _formattedkm =_format.format(_km);
      return _formattedkm;
    }


    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text('My Ads',style: TextStyle(color: Colors.black),),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorWeight: 6,
            tabs: [
              Tab(
                child: Text('ADS',style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
              Tab(
                child: Text('FAVOURITES',style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: FutureBuilder<QuerySnapshot>(
                  future: _services.products.where('sellerUid',isEqualTo: _services.user.uid).orderBy('postedAt').get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 140, right: 140),
                        child: Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'My Ads',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),),
                        Expanded(
                          child: GridView.builder(
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


                                return ProductCard(data: data, formattedPrice: _formattedPrice);
                              }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
             Center(child: Text('my favourites'),)
          ],
        ),
      ),
    );
  }
}
