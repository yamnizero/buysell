import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_stream.dart';

class ChatConversation extends StatefulWidget {
  final String chatRoomId;
  ChatConversation({this.chatRoomId});


  @override
  _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  FirebaseServices _services =FirebaseServices();


var chatMessageController = TextEditingController();

 bool _send =false;

sendMessage(){
  if(chatMessageController.text.isNotEmpty){
    Map<String,dynamic> message ={
      'messages':chatMessageController.text,
      'sentBy': _services.user.uid,
      'time':DateTime.now().microsecondsSinceEpoch,
    };
    _services.createChat(widget.chatRoomId, message);
    chatMessageController.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
              backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              icon: Icon(Icons.call),
              onPressed: (){}
              ),
          IconButton(
              icon: Icon(Icons.more_vert_sharp),
              onPressed: (){}
              ),
        ],
        shape: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatStream(widget.chatRoomId),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:Border(
                    top: BorderSide(color: Colors.grey.shade800),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: chatMessageController,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                            decoration: InputDecoration(
                              hintText: 'Type Message',
                              hintStyle: TextStyle(color:Theme.of(context).primaryColor ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                setState(() {
                                  _send = true;
                                });
                              }else{
                                setState(() {
                                  _send = false;
                                });
                              }
                            },
                            onSubmitted: (value){
                              if(value.length>0){
                                sendMessage();
                              }
                            },

                      ),
                      ),
                      Visibility(
                        visible: _send,
                        child: IconButton(icon: Icon(Icons.send,color: Theme.of(context).primaryColor),
                            onPressed:sendMessage
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
