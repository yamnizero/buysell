import 'package:buysell/provider/product_provider.dart';
import 'package:buysell/screen/home_screen.dart';
import 'package:buysell/screen/location_screen.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:buysell/services/search_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseServices _services = FirebaseServices();
  SearchServices _search =SearchServices();
  static List<Products> products = [];


  String address = '';
  DocumentSnapshot sellerDetails;

  @override
  void initState() {
    _services.products.get().then((QuerySnapshot snapshot){

      snapshot.docs.forEach((doc) {
        setState(() {
          products.add(
            Products(
              document: doc,
              title: doc['title'],
              category: doc['category'],
              description: doc['description'],
              subCat: doc['subCat'],
              postedDate: doc['postedAt'],
              price: doc['price'],
            )
          );
          getSellerAddress(doc['sellerUid']);
        });
      });
    });
    super.initState();
  }

  getSellerAddress(sellerId){
    _services.getSellerData(sellerId).then((value){
        setState(() {
          address =value['address'];
          sellerDetails=value;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);


    return FutureBuilder<DocumentSnapshot>(
      future: _services.users.doc(_services.user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        //here
        if (!snapshot.hasData==null && !snapshot.data.exists) {
          return Text("Address not selected  ");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();

          if (data['address'] == null) {
            //will check next data
            if (data['state'] == null) {
              //must be there
              GeoPoint latLong = data['location'];
              _services
                  .getAddress(latLong.latitude, latLong.longitude)
                  .then((adres) {
                //this address will show in appbar
                return appBar(adres, context);
              });
            }
          } else {
            return appBar(data['address'], context);
          }
        }
        return appBar("Fetching location", context);
      },
    );
  }

  Widget appBar(address, context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LocationScreen(popScreen:HomeScreen.id,),
              ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Flexible(
                    child: Text(
                  address,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
      bottom:  PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: InkWell(
          onTap: (){

          },
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onTap: (){
                          _search.search(context: context,productList: products,address: address,_provider: _provider);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: "Find Cars, Mobiles and many more",
                            labelStyle: TextStyle(fontSize: 12),
                            contentPadding:
                            EdgeInsets.only(left: 10, right: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.notifications_none),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
