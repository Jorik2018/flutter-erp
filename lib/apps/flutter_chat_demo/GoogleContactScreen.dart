import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_chat_demo/chat.dart';
import 'package:flutter_erp/apps/flutter_chat_demo/settings.dart';
import 'package:flutter_erp/states/auth_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';

class GoogleContactScreen extends ConsumerStatefulWidget {
  final String currentUserId;

  GoogleContactScreen({Key? key, required this.currentUserId})
    : super(key: key);

  @override
  ConsumerState createState() =>
      GoogleContactScreenState(currentUserId: currentUserId);
}

class GoogleContactScreenState extends ConsumerState<GoogleContactScreen> {
  GoogleContactScreenState({Key? key, required this.currentUserId});

  final String currentUserId;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  bool isLoading = false;

  List<Choice> choices = const <Choice>[
    Choice(title: 'Settings', icon: Icons.settings),
    Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  Future<void> registerNotification() async {
    final NotificationSettings settings = await firebaseMessaging
        .requestPermission(alert: true, badge: true, sound: true);

    print('Permiso de notificaciones: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      Fluttertoast.showToast(msg: 'El permiso de notificaciones fue rechazado');
      return;
    }

    var _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      debugPrint('Mensaje en primer plano: ${message.messageId}');
      debugPrint('Datos: ${message.data}');

      final RemoteNotification? notification = message.notification;

      if (notification != null) {
        showNotification(message.data);
      }
    });

    var _openedMessageSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) {
          debugPrint('Notificación abierta desde segundo plano');
          debugPrint('Datos: ${message.data}');

          handleNotificationNavigation(message);
        });

    final RemoteMessage? initialMessage = await firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        handleNotificationNavigation(initialMessage);
      });
    }
    await saveFirebaseToken();
    var _tokenRefreshSubscription = firebaseMessaging.onTokenRefresh.listen((
      String token,
    ) async {
      await updatePushToken(token);
    });
  }

  Future<void> saveFirebaseToken() async {
    final String? token = await firebaseMessaging.getToken();

    debugPrint('FCM token: $token');

    if (token == null) {
      debugPrint('Firebase Messaging no devolvió un token');
      return;
    }

    await updatePushToken(token);
  }

  Future<void> updatePushToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({'pushToken': token});
  }

  void handleNotificationNavigation(RemoteMessage message) {
    handleLocalNotificationNavigation(message.data);
  }

  void handleLocalNotificationNavigation(Map<String, dynamic> data) {
    if (!mounted) return;

    debugPrint('Abriendo notificación con datos: $data');

    final String? peerId = data['peerId']?.toString();
    final String? peerName = data['peerName']?.toString();
    final String? peerAvatar = data['peerAvatar']?.toString();

    if (peerId == null || peerId.isEmpty) {
      return;
    }

    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Chat(
          peerId: peerId,
          peerAvatar: peerAvatar ?? '',
          peerNickname: peerName ?? '',
          userAvatar: '',
        ),
      ),
    );
    */
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      channelDescription: 'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: message['title'].toString(),
      body: message['body'].toString(),
      notificationDetails: platformChannelSpecifics,
      payload: json.encode(message),
    );
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.only(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
              height: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.exit_to_app,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Text(
                    'Exit app',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Are you sure to exit app?',
                    style: TextStyle(color: Colors.white70, fontSize: 14.0),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.cancel),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.check_circle),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Text('YES', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        );
      },
    )) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    await ref.read(authProvider.notifier).logout();

    if (mounted) {
      this.context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAIN', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(choice.icon),
                      Container(width: 10.0),
                      Text(choice.title),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .snapshots(),
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              themeColor,
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return buildItem(context, docs[index]);
                        },
                      );
                    },
              ),
            ),
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: TextButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              themeColor,
                            ),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.account_circle, size: 50.0),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text('Nickname: ${document['nickname']}'),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Chat(peerId: document.id, peerAvatar: document['photoUrl']),
              ),
            );
          },
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;

  final IconData icon;
}
