import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductList extends StatelessWidget {
  // static const String id = "product-list-screen";

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    final _format = NumberFormat('##,##,##0');

    String _kmFormatted(km){
      var _km =int.parse(km);
      var _formattedkm =_format.format(_km);
      return _formattedkm;
    }


    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _services.products.get(),
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
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey.shade100,
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
                      childAspectRatio: 2 / 2.8,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.size,
                    itemBuilder: (BuildContext context, int i) {
                      var data = snapshot.data.docs[i];
                      //convert to int because in firestore it is in string
                      var _price = int.parse(data['price']);
                      String _formattedPrice = '\$ ${_format.format(_price)}';


                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                child: Center(
                                  child: Image.network(data['images'][0]),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                data['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(_formattedPrice,style: TextStyle(fontWeight: FontWeight.bold),),

                              data['category'] == 'Cars' ? Text('${data['year']} - ${_kmFormatted(data['kmDrive'])} km') : Text('')
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.8),
                            ),
                            borderRadius: BorderRadius.circular(4)),
                      );
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}
