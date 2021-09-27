import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatConversation extends StatefulWidget {
  final String chatRoomId;
  ChatConversation({this.chatRoomId});


  @override
  _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  FirebaseServices _services =FirebaseServices();

Stream chatMessageStream;
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
  void initState() {
   _services.getChat(widget.chatRoomId).then((value){
     setState(() {
       chatMessageStream = value;
     });

   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
            stream: chatMessageStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                  return Text(snapshot.data.docs[index]['message']);
                  }
              ): Container();
            },
        ),
          ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
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
