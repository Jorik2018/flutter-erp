import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_erp/apps/trovami/helpers/RoutesHelper.dart';
import 'package:flutter_erp/apps/trovami/httpClient/httpClient.dart';
//import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'InputTextField.dart';
import 'Roundedbutton.dart';
import 'Strings.dart';
import 'main.dart';
import 'core/OldUser.dart';
import 'signuppage.dart';
import 'homepage.dart';
import 'functionsForFirebaseApiCalls.dart';

final googleSignIn = GoogleSignIn.instance;

String? loggedinUser;

var loggedInUsername;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

final FirebaseAuth _auth = FirebaseAuth.instance;

TextStyle textStyle = new TextStyle(
  color: const Color.fromRGBO(255, 255, 255, 0.4),
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

Color textFieldColor = const Color.fromRGBO(0, 0, 0, 0.7);

ScrollController scrollController = new ScrollController();

class SignInForm extends StatefulWidget {
  @override
  SigninFormState createState() => new SigninFormState();
}

class SigninFormState extends State<SignInForm>
    with SingleTickerProviderStateMixin {
  bool _isgooglesigincomplete = true;

  bool _first = true;

  bool _autovalidate = false;

  bool _formWasEdited = false;

  final IconData mail = const IconData(0xe158, fontFamily: 'MaterialIcons');

  final IconData lock_outline = const IconData(
    0xe899,
    fontFamily: 'MaterialIcons',
  );

  final IconData signinicon = const IconData(
    0xe315,
    fontFamily: 'MaterialIcons',
  );

  final IconData signupicon = const IconData(
    0xe316,
    fontFamily: 'MaterialIcons',
  );

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  Animation<Color?>? animation;
  late AnimationController controller;

  String email = '';
  String password = '';

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  _handleSubmitted() async {
    setState(() {
      _isgooglesigincomplete = false;
    });
    try {
      _authenticateWithGoogle();
    } catch (error) {
      print(error);
    }
  }

  _authenticateWithGoogle() async {
    print(':_authenticateWithGoogle');

    final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

    //final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final GoogleSignInClientAuthorization? googleAuth = await googleUser!
        .authorizationClient
        .authorizationForScopes(['email']);

    final AuthCredential credential = GoogleAuthProvider.credential(
      //idToken: googleAuth.idToken,
      accessToken: googleAuth!.accessToken,
    );

    User? firebaseUser = (await _auth.signInWithCredential(credential)).user;
    print(':_authenticateWithGoogle2');
    GoogleSignInAccount? user;

    setState(() {
      user = googleUser;
    });
    print(':_authenticateWithGoogle3');
    if (user != null) {
      OldUser guser = new OldUser();
      guser.EmailId = user!.email;
      guser.name = user!.displayName;
      guser.locationShare = false;

      final String guserjson = jsonCodec.encode(guser);

      getUsers()
          .then((DataSnapshot response) {
            Map<dynamic, dynamic>? users =
                response.value as Map<dynamic, dynamic>;
            print(':_authenticateWithGoogle4');
            if (users != null) {
              users.forEach((k, v) {
                if (v["emailid"] == user!.email) {
                  userexists = true;
                  loggedinUser = user!.email;
                  loggedInUsername = user!.displayName;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Homepagelayout(users: response),
                    ),
                  );
                }
              });
            }
            if (userexists == false) {
              /*HttpClientFireBase httpClient = HttpClientFireBase();

        await httpClient.post(
            url: 'https://trovami-bcd81.firebaseio.com/users.json',
            body: guserjson);*/

              loggedinUser = user!.email;
              loggedInUsername = user!.displayName;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Homepagelayout(users: response),
                ),
              );
            } else {
              setState(() {
                _isgooglesigincomplete = true;
              });
            }
          })
          .catchError((e) {
            print('Got error: $e'); // Finally, callback fires.
          });
      ;
    }
  }

  _handleSubmitted2() async {
    final FormState? form = _formKey.currentState;
    if (!form!.validate()) {
      _autovalidate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form!.save();
      getUsers()
          .then((usrmap) {
            print("VVVVV");
            if (usrmap != null) {
              Map usrs = usrmap.value as Map;
              usrs.values.forEach((us) async {
                if (email == us["emailid"]) {
                  loggedinUser = email;
                  loggedInUsername = us["name"];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Homepagelayout(users: usrmap),
                    ),
                  );
                }
              });
            }
          })
          .catchError((e) {
            print('Got error: $e'); // Finally, callback fires.
          });
      //showInSnackBar(
      //  'Login EmailID or Password is incorrect. Please Try again.');
    }
  }

  String? _validateName(String? value) {
    _formWasEdited = true;
    if (value != null && value!.isEmpty) return 'EmailID is required.';
    final nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value ?? '')) return 'Please enter correct EmailID';
    return null;
  }

  setGoogleSigninListener() {
    googleSignIn.authenticationEvents.listen(
      (event) async {
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn():
            final user = event.user;
            print("Usuario logueado: ${user.email}");
            break;

          case GoogleSignInAuthenticationEventSignOut():
            print("Usuario deslogueado");
            break;
        }
      },
      onError: (error) {
        print("Error en auth: $error");
      },
    );
    googleSignIn.attemptLightweightAuthentication();
  }

  @override
  void initState() {
    super.initState();
    googleSignIn
        .initialize(
          clientId: 'TU_CLIENT_ID_SI_APLICA',
          serverClientId: 'TU_SERVER_CLIENT_ID_SI_APLICA',
        )
        .then((_) => setGoogleSigninListener());

    controller = new AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    animation =
        new ColorTween(begin: Colors.red, end: Colors.blue).animate(controller)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      body: new SingleChildScrollView(
        controller: scrollController,
        child: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('pink_house.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          child: new Column(
            children: <Widget>[
              new Container(
                height: screenSize.height / 4,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        Strings.appName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 50.0),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 3 * screenSize.height / 4,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Form(
                      key: _formKey,
                      //autovalidate: _autovalidate,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            child: new InputField(
                              hintText: 'Email',
                              obscureText: false,
                              textInputType: TextInputType.text,
                              textStyle: textStyle,
                              hintStyle: textStyle,
                              textFieldColor: textFieldColor,
                              icon: Icons.mail_outline,
                              iconColor: const Color.fromRGBO(
                                255,
                                255,
                                255,
                                0.4,
                              ),
                              bottomMargin: 20.0,
                              validateFunction: _validateName,
                              onSaved: (String? value) {
                                email = value ?? '';
                              },
                            ),
                          ),
                          new InputField(
                            hintText: 'Password',
                            obscureText: true,
                            textInputType: TextInputType.text,
                            textStyle: textStyle,
                            hintStyle: textStyle,
                            textFieldColor: textFieldColor,
                            icon: Icons.lock_outline,
                            iconColor: Colors.white,
                            bottomMargin: 20.0,
                            onSaved: (String? value) {
                              password = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new RoundedButton(
                          buttonName: 'Sign-In',
                          onTap: _handleSubmitted,
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: const Color.fromRGBO(100, 100, 100, 1.0),
                        ),
                        new RoundedButton(
                          buttonName: 'Sign-up',
                          onTap: () {
                            RoutesHelper.pushRoute(context, ROUTE_SIGNUP);
                          },
                          highlightColor: const Color.fromRGBO(
                            255,
                            255,
                            255,
                            0.1,
                          ),
                          width: screenSize.width,
                          height: 50.0,
                          bottomMargin: 10.0,
                          borderWidth: 0.0,
                          buttonColor: const Color.fromRGBO(100, 100, 100, 1.0),
                        ),

                        /// UNCOMMENT IF YOU WANT TO SIGNIN THROUGH GOOGLE
                        //                        (_isgooglesigincomplete
                        //                            ? new FloatingActionButton(
                        //                                child:
                        //                                    new Image.asset('assets/google-logo.jpg'),
                        //                                onPressed: _handleSubmitted1,
                        //                                backgroundColor: Colors.white,
                        //                              )
                        //                            : new FloatingActionButton(
                        //                                child: new CircularProgressIndicator(
                        //                                  valueColor: animation,
                        //                                ),
                        //                                onPressed: _handleSubmitted1,
                        //                                backgroundColor: Colors.white,
                        //                              )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
