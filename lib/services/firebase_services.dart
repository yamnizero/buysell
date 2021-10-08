import 'package:buysell/model/popup_menu_model.dart';
import 'package:buysell/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
  FirebaseFirestore.instance.collection('categories');
  CollectionReference products = FirebaseFirestore.instance.collection(
      'products');
  CollectionReference messages = FirebaseFirestore.instance.collection(
      'messages');

  Future<void> updateUser(Map<String, dynamic> data, context, screen) {
    return users.doc(user.uid).update(data).then((value) {
      Navigator.pushNamed(context, screen);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<String> getAddress(lat, long) async {
    // From coordinates
    final coordinates = new Coordinates(lat, long);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    return first.addressLine;
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user.uid).get();
    return doc;
  }


  Future<DocumentSnapshot> getSellerData(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot> getProductDetails(id) async {
    DocumentSnapshot doc = await products.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}) {
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      print(e.toString());
    });
  }

  createChat(String chatRoomId, message) {
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e) {
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'read': false,
    });
  }

  getChat(chatRoomId) async {
    return messages.doc(chatRoomId).collection('chats')
        .orderBy('time')
        .snapshots();
  }

  deleteChat(chatRoomId) async {
    return messages.doc(chatRoomId).delete();
  }

  updateFavourite(_isLike, productId,context) {
    if (_isLike) {
       products.doc(productId).update({
      'favourites': FieldValue.arrayUnion([user.uid]),

      });
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Added to my favourite.'),
         ),
       );

    } else {
       products.doc(productId).update({
      'favourites': FieldValue.arrayRemove([user.uid]),
      });
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Removed from favourite.'),
         ),
       );
    }
  }


  popUpMenu(chatData, context) {
    CustomPopupMenuController _controller = CustomPopupMenuController();

    List<PopupMenuModel> menuItems = [
      PopupMenuModel('Delete Chat', Icons.delete),
      PopupMenuModel('Mark as Sold', Icons.done),
    ];

    return CustomPopupMenu(
      child: Container(
        child: Icon(Icons.more_vert_sharp, color: Colors.black),
        padding: EdgeInsets.all(20),
      ),
      menuBuilder: () =>
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Colors.white,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: menuItems
                      .map(
                        (item) =>
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (item.title == 'Delete Chat') {
                              deleteChat(chatData['chatRoomId']);
                              _controller.hideMenu();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Chat delete'),
                                ),
                              );
                              ;
                            }
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  item.icon,
                                  size: 15,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding:
                                    EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: _controller,
    );
  }

}
