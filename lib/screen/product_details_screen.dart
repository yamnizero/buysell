import 'dart:async';

import 'package:buysell/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = "product-details-screen";

  const ProductDetailsScreen({Key key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;

  int _index = 0;

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);

    var data = _productProvider.productData;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                          Text('Loading your Ad')
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
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
                        ),
                      ],
                    ),
            ),
           _loading ?  Container() : Container(
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       Text(data['title'].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                       if(data['category']=='Cars')
                         Text('(${(data['year'])})'),
                     ],
                   )
                 ],
               ),
             ),
           ),
          ],
        ),
      ),
    );
  }
}
