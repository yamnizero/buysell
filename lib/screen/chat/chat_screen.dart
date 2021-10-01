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

                    return ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return ChatCard(data);
                      }).toList(),
                    );
                  },
                ),
              ),
              Container(),
              Container(),
            ],
        )
      ),
    );
  }
}
