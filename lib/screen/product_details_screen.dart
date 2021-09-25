import 'dart:async';

import 'package:buysell/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = "product-details-screen";

  const ProductDetailsScreen({Key key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  GoogleMapController _controller;
  bool _loading = true;

  int _index = 0;

  final _format =NumberFormat('##,##,##0');

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  _mapLauncher(location)async{
    final availableMaps = await launcher.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude,location.longitude),
      title: "Seller Location is here",
    );
  }

  _callSeller(number){
    launch(number);
  }

  @override
  Widget build(BuildContext context) {

    var _productProvider = Provider.of<ProductProvider>(context);
    GeoPoint _location =_productProvider.sellerDetails['location'];


    var data = _productProvider.productData;
    var _price = int.parse(data['price']);
    String price = _format.format(_price);


    var date = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);
    var _date =DateFormat.yMMMd().format(date);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          LikeButton(
            circleColor:
                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.grey.shade300,
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Loading your Ad'),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                imageProvider: NetworkImage(data['images'][_index]),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data['images'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: ()
                                      {
                                        setState(() {
                                          _index = i;
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(data['images'][i]),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              SizedBox(height: 10,),
              _loading
                  ? Container()
                   :Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Text(data['title'].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,
                         fontSize: 20,
                         ),),
                         if(data['category']=='Cars')
                           Text('(${(data['year'])})'),
                       ],
                     ),
                     SizedBox(height:30,),
                     Text('\$ $price',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 ),),
                     SizedBox(height:10,),
                     if(data['category']=='Cars')
                       Container(
                         color: Colors.grey.shade300,
                         child: Padding(
                           padding: const EdgeInsets.only(top: 10,bottom: 10),
                           child: Column(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Icon(Icons.filter_alt_outlined,size: 12,),
                                       SizedBox(width: 10,),
                                       Text(data['fuel'],style: TextStyle(fontSize: 12),),
                                     ],
                                   ),
                                   Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Icon(Icons.av_timer_outlined ,size: 12,),
                                       SizedBox(width: 10,),
                                       Text(_format.format(int.parse(data['kmDrive'])),style: TextStyle(fontSize: 12),),
                                     ],
                                   ),

                                   Row(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       Icon(Icons.account_tree_outlined ,size: 12,),
                                       SizedBox(width: 10,),
                                       Text(data['transmission'],style: TextStyle(fontSize: 12),),
                                     ],
                                   ),
                                 ],
                               ),
                               Divider(color: Colors.grey,),
                               Padding(
                                 padding: const EdgeInsets.only(left: 12,right: 12 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   children: [
                                     Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Icon(CupertinoIcons.person,size: 12,),
                                         SizedBox(width: 10,),
                                         Text(data['noOfOwners'],style: TextStyle(fontSize: 12),),
                                       ],
                                     ),
                                     SizedBox(width: 20,),
                                     Expanded(
                                       child: Container(
                                         child: AbsorbPointer(
                                           //disable button
                                           absorbing: true,
                                           child: TextButton.icon(
                                               onPressed: () {},
                                             style: ButtonStyle(alignment: Alignment.center),
                                               icon: Icon(Icons.location_on_outlined,size: 12,color: Colors.black,),
                                             //need to bring address here
                                               label: Flexible(
                                                 child: Text(_productProvider.sellerDetails == null ? '' : _productProvider.sellerDetails['address'],
                                                 maxLines: 1,
                                                   style: TextStyle(color: Colors.black),
                                                 ),
                                               ),
                                           ),
                                         ),
                                       ),
                                     ),
                                     Container(
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text('POSTED DATE',style: TextStyle(fontSize: 12),),
                                           //need to convert to date
                                           Text(_date,style: TextStyle(fontSize: 12),),
                                         ],
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     SizedBox(height: 10,),
                     Text('Description',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                     SizedBox(height: 10,),
                     Row(
                       children: [
                         Expanded(
                           child: Container(
                             color: Colors.grey.shade300,
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(data['description']),
                                   SizedBox(height: 10,),
                                   //only  for mobile
                                   if(data['subCat'] == null || data['subCat'] == 'Mobiles Android')
                                     Text('Brand: ${data['brand']}'),
                                   if(data['subCat'] == 'Accessories' ||
                                       data['subCat'] == 'Tablets'  ||
                                       data['subCat'] == 'sell : House & Apartments' ||
                                       data['subCat'] == 'Rent :House & Apartments' )
                                     Text('Type: ${data['type']}'),
                                   if( data['subCat'] == 'sell : House & Apartments' ||
                                       data['subCat'] == 'Rent :House & Apartments' )
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start ,
                                       children: [
                                         Text('Bedrooms: ${data['bedrooms']}'),
                                         Text('Bathrooms: ${data['bathrooms']}'),
                                         Text('Furnishing: ${data['furnishing']}'),
                                         Text('Construction Status: ${data['ConstructionStatus']}'),
                                         Text('Total Floors: ${data['totalFloors']}'),
                                       ],
                                     ),
                                   SizedBox(height: 20,),
                                   Text('Posted at: $_date'),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                     Divider(color: Colors.grey,),
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
                          child: ListTile(
                            title: Text(_productProvider.sellerDetails == null ? '' : _productProvider.sellerDetails['name'].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            subtitle: Text('SEE PROFILE',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                            trailing: IconButton(icon: Icon(Icons.arrow_forward_ios,size: 12,), onPressed: (){}),
                        )
                        )
                       ],
                     ),
                     Divider(color: Colors.grey,),
                     Text('Add Posted at',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                     SizedBox(height: 10,),
                     Container(
                       height: 200,
                       color: Colors.grey.shade300,
                       //google map here
                       child: Stack(
                         children: [
                           Center(
                               child: GoogleMap(
                                 initialCameraPosition: CameraPosition(
                                   target: LatLng(_location.latitude,_location.longitude),
                                   zoom: 15,
                                 ),
                                 mapType: MapType.normal,
                                 onMapCreated:(GoogleMapController controller){
                                   setState(() {
                                     _controller = controller;
                                   });
                                 },

                               ),
                           ),
                           Center(child: Icon(Icons.location_on,size: 35,)),
                           Center(child: CircleAvatar(radius: 60 ,backgroundColor: Colors.black12,),),
                           Positioned(
                             right: 4.0,
                           top: 4.0,
                           child: Material(
                             elevation: 4,
                             shape: Border.all(color: Colors.grey.shade300),
                             child: IconButton(icon: Icon(Icons.alt_route_outlined),
                             onPressed: (){
                               //launch location in google map
                               _mapLauncher(_location);
                             },
                             ),
                           ),
                           )
                         ],
                       ),
                     ),
                     SizedBox(height: 10,),
                     Row(
                       children: [
                         Expanded(child: Text('AD ID : ${data['postedAt']}',style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 16),)),
                         TextButton(
                           onPressed: (){},
                           child: Text('REPORT THIS AD',style: TextStyle(color: Colors.blue),

                           ),
                         ),

                       ],
                     ),
                     SizedBox(height: 80,),
                   ],
                 ),
               ),

              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: NeumorphicButton(
                onPressed: (){},
                style: NeumorphicStyle(
                  color: Theme.of(context).primaryColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.chat_bubble,size: 16 ,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Chat',style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),),
              SizedBox(width: 20,),
              Expanded(child: NeumorphicButton(
                onPressed: (){
                  //call seller
                  _callSeller('tel:${_productProvider.sellerDetails['mobile']}');

                },
                style: NeumorphicStyle(
                  color: Theme.of(context).primaryColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.phone,size: 16 ,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text('Call',style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),),

            ],
          ),
        ),
      ),
    );
  }
}
