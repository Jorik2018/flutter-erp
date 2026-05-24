import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_chat_app/ChatMessageListItem.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

final GoogleSignIn googleSignIn = GoogleSignIn.instance;

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

final FirebaseAuth auth = FirebaseAuth.instance;

GoogleSignInAccount? _user;

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    googleSignIn.initialize(
      clientId: null, // opcional en Android
    );
  }

  final TextEditingController _textEditingController = TextEditingController();

  bool _isComposingMessage = false;

  final reference = FirebaseDatabase.instance.ref().child('messages');

  void _sendMessage({String? messageText, String? imageUrl}) {
    if (_user == null) return;

    reference.push().set({
      'text': messageText,
      'email': _user!.email,
      'imageUrl': imageUrl,
      'senderName': _user!.displayName,
      'senderPhotoUrl': _user!.photoUrl,
    });

    analytics.logEvent(name: 'send_message');
  }

  Future<void> _ensureLoggedIn() {
    return googleSignIn
        .authenticate()
        .then((account) {
          _user = account;
          final credential = GoogleAuthProvider.credential(
            idToken: account.authentication.idToken,
          );
          return auth.signInWithCredential(credential).then((_) {
            currentUserEmail = account.email;
            return analytics.logLogin();
          });
        })
        .catchError((e) {
          if (e is GoogleSignInException &&
              e.code == GoogleSignInExceptionCode.canceled) {
            print("Usuario canceló login");
          } else {
            print("Error real: $e");
          }
        });
  }

  Future<void> _signOut() async {
    await auth.signOut();

    await googleSignIn.signOut();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('User logged out')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat App"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _signOut),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: FirebaseAnimatedList(
                query: reference,
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                sort: (a, b) => b.key!.compareTo(a.key!),
                //comparing timestamp of messages to check which one would appear first
                itemBuilder:
                    (
                      _,
                      DataSnapshot messageSnapshot,
                      Animation<double> animation,
                      _,
                    ) {
                      return ChatMessageListItem(
                        messageSnapshot: messageSnapshot,
                        animation: animation,
                      );
                    },
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
            Builder(
              builder: (BuildContext context) {
                return Container(width: 0.0, height: 0.0);
              },
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              )
            : null,
      ),
    );
  }

  CupertinoButton getIOSSendButton() {
    return CupertinoButton(
      child: Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: _isComposingMessage
            ? Theme.of(context).focusColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).focusColor,
                ),
                onPressed: () async {
                  await _ensureLoggedIn();
                  await ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((pickedFile) async {
                        final File imageFile = File(pickedFile!.path);
                        final String fileName =
                            'img_${DateTime.now().millisecondsSinceEpoch}.jpg';

                        final Reference storageRef = FirebaseStorage.instance
                            .ref()
                            .child(fileName);
                        storageRef
                            .putFile(imageFile)
                            .then((TaskSnapshot uploadTask) {
                              return uploadTask.ref.getDownloadURL();
                            })
                            .then((String downloadUrl) {
                              _sendMessage(imageUrl: downloadUrl.toString());
                            });
                      });
                },
              ),
            ),
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onChanged: (String messageText) {
                  setState(() {
                    _isComposingMessage = messageText.length > 0;
                  });
                },
                onSubmitted: _textMessageSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? getIOSSendButton()
                  : getDefaultSendButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      _isComposingMessage = false;
    });
    return _ensureLoggedIn().then((_) {
      _sendMessage(messageText: text);
    });
  }
}
