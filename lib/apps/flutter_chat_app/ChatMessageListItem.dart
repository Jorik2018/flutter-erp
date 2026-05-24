import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;

  final Animation<double> animation;

  ChatMessageListItem({required this.messageSnapshot, required this.animation});

  @override
  Widget build(BuildContext context) {
    final message = messageSnapshot.value as Map?;
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          /**The method '[]' can't be unconditionally invoked because the receiver can be 'null'.
Try making the call conditional (using '?.') or adding a null check to the target ('!'). */
          children: currentUserEmail == message!['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    final message = messageSnapshot.value as Map?;
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              message!['senderName'],
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: message['imageUrl'] != null
                  ? Image.network(message['imageUrl'], width: 250.0)
                  : Text(message!['text']),
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message!['senderPhotoUrl']),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    final message = messageSnapshot.value as Map?;
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message!['senderPhotoUrl']),
            ),
          ),
        ],
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message!['senderName'],
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: message!['imageUrl'] != null
                  ? Image.network(message['imageUrl']!, width: 250.0)
                  : Text(message!['text'] as String),
            ),
          ],
        ),
      ),
    ];
  }
}
