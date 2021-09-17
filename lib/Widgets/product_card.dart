import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';



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

  String _kmFormatted(km){
    var _km =int.parse(km);
    var _formattedkm =_format.format(_km);
    return _formattedkm;
  }
  @override
  void initState() {
    _services.getSellerData(widget.data['sellerUid']).then((value){
     if(mounted){
       setState(() {
         address = value['address'];
       });
     }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
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
                Text(widget._formattedPrice,style: TextStyle(fontWeight: FontWeight.bold),),

                widget.data['category'] == 'Cars' ? Text('${widget.data['year']} - ${_kmFormatted(widget.data['kmDrive'])} km') : Text(''),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.location_pin,size: 14,color: Colors.black38,),
                    Flexible(child: Text(address,maxLines: 1,overflow: TextOverflow.ellipsis,),),
                  ],
                ),

              ],
            ),
            Positioned(
              right: 0.0,
              child:  CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: LikeButton(
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
                ),
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
    );
  }
}