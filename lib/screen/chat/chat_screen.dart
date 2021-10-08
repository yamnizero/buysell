import 'package:buysell/screen/main_screen.dart';
import 'package:buysell/screen/sellItems/seller_category_list.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_card.dart';

class ChatScreen extends StatelessWidget {
  static const String id = "chat-screen";

  @override
  Widget build(BuildContext context) {

    FirebaseServices _services=FirebaseServices();

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text('Chats',style: TextStyle(color: Theme.of(context).primaryColor),),
          bottom:TabBar(
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            labelColor: Theme.of(context).primaryColor,
            indicatorWeight: 6,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'ALL',),
              Tab(text: 'BUYING',),
              Tab(text: 'SELLING',),
            ],
          ),

        ),
        body: TabBarView(
            children: [
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _services.messages.where('users',arrayContains: _services.user.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),);
                    }


                    if(snapshot.data.docs.length==0){
                      return Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No Chats started yet',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            child: Text('Contact Seller'),
                            onPressed: (){
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                          )
                        ],
                      ),);
                    }


                    return ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return ChatCard(data);
                      }).toList(),
                    );
                  },
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _services.messages.where('users',arrayContains: _services.user.uid).where('product.seller',isNotEqualTo: _services.user.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),);
                    }
                    if(snapshot.data.docs.length==0){
                      return Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No Ads buying yet',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            child: Text('Buy Product'),
                            onPressed: (){
                              Navigator.pushNamed(context, SellerCategory.id);

                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                          )
                        ],
                      ),);
                    }

                    return ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return ChatCard(data);
                      }).toList(),
                    );
                  },
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _services.messages.where('users',arrayContains: _services.user.uid).where('product.seller',isEqualTo: _services.user.uid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),);
                    }

                    if(snapshot.data.docs.length==0){
                      return Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No Ads given yet',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            child: Text('Ad Product'),
                              onPressed: (){},
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),),
                          )
                        ],
                      ),);
                    }

                    return ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return ChatCard(data);
                      }).toList(),
                    );
                  },
                ),
              ),

            ],
        )
      ),
    );
  }
}
