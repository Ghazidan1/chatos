import 'package:chatos/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? loggedInUser;
  String? message;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _fireStore.collection('Messages').add(
                          {'text': message, 'sender': loggedInUser!.email});
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('Messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('Empety Chat'),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messagesWidgets = [];
        for (var message in messages!) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = _auth.currentUser?.email;
          messagesWidgets.add(MessageBubble(
            messageSender: messageSender,
            messageText: messageText,
            isMe: currentUser != messageSender,
          ));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messagesWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final bool isMe;

  MessageBubble(
      {required this.messageText,
      required this.messageSender,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              messageSender.split('@').first,
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            Material(
              borderRadius: isMe
                  ? BorderRadius.circular(30.0).copyWith(topLeft: Radius.zero)
                  : BorderRadius.circular(30.0).copyWith(topRight: Radius.zero),
              color: isMe ? Colors.white : Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '$messageText ',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: isMe ? Colors.black54 : Colors.white),
                ),
              ),
            ),
          ]),
    );
  }
}
