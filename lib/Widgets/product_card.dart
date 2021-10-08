import 'package:buysell/provider/product_provider.dart';
import 'package:buysell/screen/product_details_screen.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';



class ProductCard extends StatefulWidget {
  const ProductCard({
    Key key,
    @required this.data,
    @required String formattedPrice,
  }) : _formattedPrice = formattedPrice, super(key: key);

  final QueryDocumentSnapshot<Object> data;
  final String _formattedPrice;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseServices _services =FirebaseServices();
  final _format = NumberFormat('##,##,##0');

  String address = '';
  DocumentSnapshot sellerDetails;
  List fav =[];
  bool _isLike =false;


  String _kmFormatted(km){
    var _km =int.parse(km);
    var _formattedkm =_format.format(_km);
    return _formattedkm;
  }
  @override
  void initState() {
    getSellerData();
    getFavourites();
    super.initState();
  }

  getSellerData(){
    _services.getSellerData(widget.data['sellerUid']).then((value){
      if(mounted){
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
  }

  getFavourites(){
    _services.products.doc(widget.data.id).get().then((value){
     if(mounted){
       setState(() {
         fav=value['favourites'];
       });
     }
      if(fav.contains(_services.user.uid)){
        if(mounted){
          setState(() {
            _isLike = true;
          });
        }
      }else{
        if(mounted){
          setState(() {
            _isLike = false;
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);

    return InkWell(
      onTap: (){
       _provider.getProductDetails(widget.data);
       _provider.getSellerDetails(sellerDetails);
        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          child: Center(
                            child: Image.network(widget.data['images'][0]),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          widget.data['title'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(widget._formattedPrice,style: TextStyle(fontWeight: FontWeight.bold
                        ),
                        ),
                        widget.data['category'] == 'Cars' ? Text('${widget.data['year']} - ${_kmFormatted(widget.data['kmDrive'])} km') : Text(''),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_pin,size: 14,color: Colors.black38,),
                      Flexible(child: Text(address,maxLines: 1,overflow: TextOverflow.ellipsis,),),
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0.0,
                child:  IconButton(
                  icon: Icon(_isLike ?Icons.favorite :Icons.favorite_border),
                  color: _isLike ? Colors.red : Colors.black,
                  onPressed: (){
                    setState(() {
                      _isLike = !_isLike;
                    });
                    _services.updateFavourite(_isLike, widget.data.id, context);
                  },
                ),
                 ),
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
      ),
    );
  }
}








