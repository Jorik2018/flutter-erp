// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'type_meme.dart';
import 'platform_adaptive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memechat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<ChatMessage> _messages = [];

  DatabaseReference _messagesReference = FirebaseDatabase.instance.ref();

  TextEditingController _textController = TextEditingController();

  bool _isComposing = false;

  GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  var fireBaseSubscription;

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _initGoogleSignIn();
    FirebaseAuth.instance.signInAnonymously().then((user) {
      fireBaseSubscription = _messagesReference
          .orderByChild('timestamp')
          .onChildAdded
          .listen((DatabaseEvent event) {
            final data = event.snapshot.value as Map?;

            if (data == null) return;

            final sender = data['sender'] as Map?;

            _addMessage(
              name: sender?['name'],
              senderImageUrl: sender?['imageUrl'],
              text: data['text'],
              imageUrl: data['imageUrl'],
              textOverlay: data['textOverlay'],
            );
          });
    });
  }

  Future<void> _initGoogleSignIn() async {
    await _googleSignIn.initialize();

    _googleSignIn.authenticationEvents.listen((event) {
      final user = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };

      setState(() {
        _currentUser = user;
      });
    });

    _googleSignIn.attemptLightweightAuthentication();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    fireBaseSubscription.cancel();
    super.dispose();
  }

  void _handleMessageChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();

    if (_currentUser == null) {
      await _googleSignIn.authenticate();
    }

    if (_currentUser == null) return;

    final message = {
      'sender': {
        'name': _currentUser!.displayName,
        'imageUrl': _currentUser!.photoUrl,
      },
      'text': text,
      'timestamp': ServerValue.timestamp,
    };

    await _messagesReference.push().set(message);

    setState(() {
      _isComposing = false;
    });
  }

void _addMessage({
    String? name,
    String? text,
    String? imageUrl,
    String? textOverlay,
    String? senderImageUrl,
  }) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    final sender = ChatUser(
      name: name ?? 'Anon',
      imageUrl: senderImageUrl ?? '',
    );

    final message = ChatMessage(
      sender: sender,
      text: text ?? '',
      imageUrl: imageUrl ?? '',
      textOverlay: textOverlay ?? '',
      animationController: animationController,
    );

    setState(() {
      _messages.insert(0, message);
    });

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final image = NetworkImage(imageUrl);
      image
          .resolve(createLocalImageConfiguration(context))
          .addListener(
        ImageStreamListener((_, __) {
          animationController.forward();
        }),
      );
    } else {
      animationController.forward();
    }
  }

  Future<Null> _handlePhotoButtonPressed() async {
    if (_currentUser == null) {
      await _googleSignIn.authenticate();
    }

    if (_currentUser == null) return;
    var picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    var random = Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref().child('image_$random.jpg');
    final imageFile = File(picked!.path);
    ref.putFile(imageFile);
    /**The argument type 'XFile?' can't be assigned to the parameter type 'File'.  */
    var textOverlay = await Navigator.push(context, TypeMemeRoute(imageFile));
    if (textOverlay == null) return;
    String downloadUrl = await ref.getDownloadURL();
    var message = {
      'sender': {'name': _currentUser!.displayName, 'imageUrl': _currentUser!.photoUrl},
      'imageUrl': downloadUrl.toString(),
      'textOverlay': textOverlay,
    };
    _messagesReference.push().set(message);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).highlightColor),
      child: PlatformAdaptiveContainer(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.photo),
                onPressed: _handlePhotoButtonPressed,
              ),
            ),
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                onChanged: _handleMessageChanged,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: PlatformAdaptiveButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlatformAdaptiveAppBar(
        title: Text('Memechat'),
        platform: Theme.of(context).platform,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) =>
                  ChatMessageListItem(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatUser {
  ChatUser({required this.name, required this.imageUrl});
  final String name;
  final String imageUrl;
}

class ChatMessage {
  ChatMessage({
    required this.sender,
    required this.text,
    required this.imageUrl,
    required this.textOverlay,
    required this.animationController,
  });
  final ChatUser sender;
  final String text;
  final String imageUrl;
  final String textOverlay;
  final AnimationController animationController;
}

class ChatMessageListItem extends StatelessWidget {
  ChatMessageListItem(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: message.animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(message.sender.imageUrl),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.sender.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: ChatMessageContent(message),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageContent extends StatelessWidget {
  ChatMessageContent(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    if (message.imageUrl != null) {
      var image = Image.network(message.imageUrl, width: 200.0);
      if (message.textOverlay == null) {
        return image;
      } else {
        return Stack(
          alignment: FractionalOffset.topCenter,
          children: [
            image,
            Container(
              alignment: FractionalOffset.topCenter,
              width: 200.0,
              child: Text(
                message.textOverlay,
                style: const TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 30.0,
                  color: Colors.white,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }
    } else
      return Text(message.text);
  }
}
