import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/user.dart' as app_user;
import 'feed.dart';
import 'upload_page.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBA;
import 'profile_page.dart';
import 'search_page.dart';
import 'activity_feed.dart';
import 'create_account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

final auth = FBA.FirebaseAuth.instance;
final googleSignIn = GoogleSignIn.instance;
final ref = FirebaseFirestore.instance.collection('insta_users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

app_user.User? currentUserModel;

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/contacts.readonly',
];

Future<Null> _ensureLoggedIn(BuildContext context) async {
  /*GoogleSignInAccount? user = googleSignIn.currentUser;
  if (user == null) {
    user = await googleSignIn.signInSilently();
  }
  if (user == null) {
    await googleSignIn.signIn();
    await tryCreateUserRecord(context);
  }

  if (auth.currentUser == null) {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FBA.GoogleAuthCredential credential =
        FBA.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

    await auth.signInWithCredential(credential);
  }*/
}

Future<Null> _silentLogin(BuildContext context) async {
  /*GoogleSignInAccount? user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signInSilently();
    await tryCreateUserRecord(context);
  }

  if (await auth.currentUser == null && user != null) {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FBA.GoogleAuthCredential credential =
        FBA.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

    await auth.signInWithCredential(credential);
  }*/
}

Future<Null> _setUpNotifications() async {
  if (Platform.isAndroid) {
    /*_firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: " + token);

      FirebaseFirestore.instance
          .collection("insta_users")
          .doc(currentUserModel.id)
          .update({"androidNotificationToken": token});
    });*/
  }
}

Future<void> tryCreateUserRecord(BuildContext context) async {
  GoogleSignInAccount? user = null; //googleSignIn.currentUser;
  if (user == null) {
    return null;
  }
  DocumentSnapshot userRecord = await ref.doc(user.id).get();
  if (userRecord.data() == null) {
    // no user record exists, time to create

    String? userName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Center(
          child: Scaffold(
            appBar: AppBar(
              leading: Container(),
              title: Text(
                'Fill out missing data',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              children: <Widget>[Container(child: CreateAccount())],
            ),
          ),
        ),
      ),
    );

    if (userName != null || userName!.length != 0) {
      ref.doc(user.id).set({
        "id": user.id,
        "username": userName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "followers": {},
        "following": {},
      });
    }
    userRecord = await ref.doc(user.id).get();
  }

  currentUserModel = app_user.User.fromDocument(userRecord);
  return null;
}

class FluttergramPage extends StatefulWidget {
  FluttergramPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _FluttergramPageState createState() => _FluttergramPageState();
}

late PageController pageController;

class _FluttergramPageState extends State<FluttergramPage> {
  int _page = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;
  bool firebaseInitialized = false;

  Scaffold buildLoginPage() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 240.0),
          child: Column(
            children: <Widget>[
              Text(
                'Fluttergram',
                style: TextStyle(
                  fontSize: 60.0,
                  fontFamily: "Billabong",
                  color: Colors.black,
                ),
              ),
              Padding(padding: const EdgeInsets.only(bottom: 100.0)),
              GestureDetector(
                onTap: login,
                child: Image.asset(
                  "assets/images/google_signin_button.png",
                  width: 225.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (triedSilentLogin == false) {
      silentLogin(context);
    }

    if (setupNotifications == false && currentUserModel != null) {
      setUpNotifications();
    }

    if (!firebaseInitialized) return CircularProgressIndicator();

    auth.authStateChanges().listen((event) {
      if (event == null) {
        silentLogin(context);
      }
    });

    return (currentUserModel == null)
        ? buildLoginPage()
        : Scaffold(
            body: PageView(
              children: [
                Container(color: Colors.white, child: Feed()),
                Container(color: Colors.white, child: SearchPage()),
                Container(color: Colors.white, child: Uploader()),
                Container(color: Colors.white, child: ActivityFeedPage()),
                Container(
                  color: Colors.white,
                  child: ProfilePage(userId: currentUserModel!.id),
                ),
              ],
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: onPageChanged,
            ),
            /**The method 'CupertinoTabBar' isn't defined for the type '_HomePageState'.
Try correcting the name to the name of an existing method, or defining a method named 'CupertinoTabBar' */
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: (_page == 0) ? Colors.black : Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: (_page == 1) ? Colors.black : Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle,
                    color: (_page == 2) ? Colors.black : Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.star,
                    color: (_page == 3) ? Colors.black : Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: (_page == 4) ? Colors.black : Colors.grey,
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          );
  }

  void login() async {
    await _ensureLoggedIn(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  void setUpNotifications() {
    _setUpNotifications();
    setState(() {
      setupNotifications = true;
    });
  }

  void silentLogin(BuildContext context) async {
    await _silentLogin(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      setState(() {
        firebaseInitialized = true;
      });
    });
    pageController = PageController();

    final GoogleSignIn signIn = GoogleSignIn.instance;
    unawaited(
      signIn
          .initialize(clientId: "clientId", serverClientId: "serverClientId")
          .then((_) {
            signIn.authenticationEvents
                .listen(_handleAuthenticationEvent)
                .onError(_handleAuthenticationError);

            /// This example always uses the stream-based approach to determining
            /// which UI state to show, rather than using the future returned here,
            /// if any, to conditionally skip directly to the signed-in state.
            signIn.attemptLightweightAuthentication();
          }),
    );
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
        // #enddocregion CheckAuthorization
        switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };

    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization

    setState(() {
      //_currentUser = user;
      //_isAuthorized = authorization != null;
      //_errorMessage = '';
    });

    // If the user has already granted access to the required scopes, call the
    // REST API.
    //if (user != null && authorization != null) {
    //unawaited(_handleGetContact(user));
    //}
  }

  Future<void> _handleAuthenticationError(Object e) async {
    setState(() {
      //_currentUser = null;
      //_isAuthorized = false;
      //_errorMessage =
      //  e is GoogleSignInException
      //    ? _errorMessageFromSignInException(e)
      //  : 'Unknown error: $e';
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
