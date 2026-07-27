import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/registration_login/utils/list_item.dart';
import 'package:flutter_erp/apps/registration_login/utils/navigation_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_erp/apps/registration_login/utils/util.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //final FacebookLogin _facebookLogin = FacebookLogin();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _LoginData _data = _LoginData();
  bool _googleSignInInitialized = false;
  bool _isLoading = false;

  Future<void> _initializeGoogleSignIn() async {
    if (_googleSignInInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      // En Android normalmente se obtiene de google-services.json.
      // En Web puede ser necesario:
      // clientId: 'TU_WEB_CLIENT_ID',

      // Necesario si enviarás credenciales a un backend.
      // serverClientId: 'TU_WEB_CLIENT_ID',
    );

    _googleSignInInitialized = true;
  }

  void _setLoading(bool loading) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = loading;
    });
  }

  Future<User> _googleSignInButton() async {
    try {
      _setLoading(true);

      UserCredential userCredential;

      if (kIsWeb) {
        final GoogleAuthProvider provider = GoogleAuthProvider();

        provider.addScope('email');
        provider.addScope('profile');

        userCredential = await _fireBaseAuth.signInWithPopup(provider);
      } else {
        await _initializeGoogleSignIn();

        final GoogleSignInAccount googleAccount = await _googleSignIn
            .authenticate();

        final GoogleSignInAuthentication googleAuthentication =
            googleAccount.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
        );

        userCredential = await _fireBaseAuth.signInWithCredential(credential);
      }

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Firebase no devolvió el usuario autenticado.',
        );
      }

      Util.userName = firebaseUser.displayName ?? '';
      Util.emailId = firebaseUser.email ?? '';
      Util.profilePic = firebaseUser.photoURL ?? '';

      if (mounted) {
        NavigationRouter.switchToHome(context);
      }

      return firebaseUser;
    } on GoogleSignInException catch (error) {
      _showMessage(
        error.description ?? 'No se pudo iniciar sesión con Google.',
      );

      rethrow;
    } on FirebaseAuthException catch (error) {
      _showMessage(error.message ?? 'Firebase rechazó el inicio de sesión.');

      rethrow;
    } catch (error) {
      _showMessage('Error al iniciar sesión con Google: $error');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<Null> _facebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile', 'user_posts'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final AccessToken? accessToken = result.accessToken;

          if (accessToken == null) {
            _showMessage('Facebook no devolvió un token de acceso.');
            return null;
          }

          // Datos básicos del usuario.
          final Map<String, dynamic> user = await FacebookAuth.instance
              .getUserData(
                fields: 'name,first_name,last_name,email,picture.width(300)',
              );

          final Map<String, dynamic>? picture =
              user['picture'] as Map<String, dynamic>?;

          final Map<String, dynamic>? pictureData =
              picture?['data'] as Map<String, dynamic>?;

          Util.userName = user['name']?.toString() ?? '';
          Util.emailId = user['email']?.toString() ?? '';
          Util.profilePic = pictureData?['url']?.toString() ?? '';

          // Conserva la consulta del feed del código original.
          final Response<dynamic> graphResponseFeed = await Dio().get(
            'https://graph.facebook.com/me/feed',
            queryParameters: {
              'fields': 'message',
              'access_token': accessToken.tokenString,
            },
          );

          final Map<String, dynamic> feedMessages = _responseToMap(
            graphResponseFeed.data,
          );

          debugPrint('Feed: $feedMessages');

          // Consulta publicaciones con mensajes y adjuntos.
          final Response<dynamic> graphResponseFeedWithAttachments = await Dio()
              .get(
                'https://graph.facebook.com/me/feed',
                queryParameters: {
                  'fields':
                      'message,attachments{description,media,target,type,url}',
                  'access_token': accessToken.tokenString,
                },
              );

          final Map<String, dynamic> root = _responseToMap(
            graphResponseFeedWithAttachments.data,
          );

          final List<dynamic> feedData =
              (root['data'] as List<dynamic>?) ?? const [];

          // Evita acumular publicaciones de inicios de sesión anteriores.
          Util.descriptionList.clear();
          Util.mediaList.clear();

          for (final dynamic feedItem in feedData) {
            if (feedItem is! Map<String, dynamic>) {
              continue;
            }

            final Map<String, dynamic>? attachments =
                feedItem['attachments'] as Map<String, dynamic>?;

            if (attachments == null) {
              continue;
            }

            final List<dynamic> attachmentData =
                (attachments['data'] as List<dynamic>?) ?? const [];

            for (final dynamic attachmentItem in attachmentData) {
              if (attachmentItem is! Map<String, dynamic>) {
                continue;
              }

              final Map<String, dynamic>? media =
                  attachmentItem['media'] as Map<String, dynamic>?;

              final Map<String, dynamic>? image =
                  media?['image'] as Map<String, dynamic>?;

              final String? imageUrl = image?['src']?.toString();

              final String description =
                  attachmentItem['description']?.toString() ??
                  feedItem['message']?.toString() ??
                  '';

              if (imageUrl == null || imageUrl.isEmpty) {
                continue;
              }

              debugPrint(imageUrl);

              Util.descriptionList.add(description);
              Util.mediaList.add(imageUrl);
            }
          }

          if (!mounted) {
            return null;
          }

          NavigationRouter.switchToHome(context);
          break;

        case LoginStatus.cancelled:
          _showMessage('Login cancelled by the user.');
          break;

        case LoginStatus.failed:
          _showMessage(
            'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: '
            '${result.message ?? 'Unknown error'}',
          );
          break;

        case LoginStatus.operationInProgress:
          _showMessage('Facebook login is already in progress.');
          break;
      }
    } on DioException catch (error) {
      final dynamic responseData = error.response?.data;

      String message = 'No se pudo consultar Facebook Graph API.';

      if (responseData is Map<String, dynamic>) {
        final dynamic graphError = responseData['error'];

        if (graphError is Map<String, dynamic>) {
          message = graphError['message']?.toString() ?? message;
        }
      }

      _showMessage(message);
    } catch (error, stackTrace) {
      debugPrint('Facebook login error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showMessage('Facebook login error: $error');
    }

    return null;
  }

  Map<String, dynamic> _responseToMap(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    if (responseData is String) {
      final dynamic decoded = jsonDecode(responseData);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }

    return <String, dynamic>{};
  }

  Future<Null> _logOut() async {
    try {
      await FacebookAuth.instance.logOut();

      Util.userName = '';
      Util.emailId = '';
      Util.profilePic = '';
      Util.descriptionList.clear();
      Util.mediaList.clear();

      _showMessage('Logged out.');
    } catch (error) {
      _showMessage('Could not log out: $error');
    }

    return null;
  }

  void _showMessage(message) {
    setState(() {
      //_message = message!;
    });
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (!(value!.length > 0 && value.contains("@") && value!.contains("."))) {
      return 'The E-mail Address must be a valid email address.';
    }
    return null;
  }

  void _submit() {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

      print('Printing the login data.');
      print('Email: ${_data.email}');
      print('Password: ${_data.password}');
    }
  }

  /* void _performLogin() {
   // This is just a demo, so no actual login here.
   final snackbar = SnackBar(
     content:Text('Email: $_email, password: $_password'),
   );

   scaffoldKey.currentState.showSnackBar(snackbar);
 }*/
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    final Size screenSize = media.size;
    return Scaffold(
      //key: this.scaffoldKey,
      appBar: AppBar(title: Text('Login')),
      body: Container(
        padding: EdgeInsets.all(20.0),

        child: Form(
          key: this._formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[FlutterLogo(size: 100.0)],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // Use email input type for emails.
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    labelText: 'E-mail Address',
                    icon: Icon(Icons.email),
                  ),
                  validator: this._validateEmail,
                  onSaved: (String? value) {
                    this._data!.email = value!;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  obscureText: true, // Use secure text for passwords.
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Enter your password',
                    icon: Icon(Icons.lock),
                  ),
                  validator: this._validatePassword,
                  onSaved: (String? value) {
                    this._data!.password = value!;
                  },
                ),
              ),
              Container(
                width: screenSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(left: 10.0, top: 30.0),
                      child: ElevatedButton(
                        child: Text('Login'),
                        onPressed: this._submit,
                      ),
                    ),
                    Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(left: 20.0, top: 30.0),
                      child: ElevatedButton(
                        child: Text('Registration'),
                        onPressed: _navigateRegistration,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenSize.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 210.0,
                            child: ElevatedButton.icon(
                              label: Text(
                                'Login with Google+',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Image.asset(
                                "assets/google_plus.png",
                                width: 24.0,
                                height: 24.0,
                              ),
                              onPressed: () => _googleSignInButton()
                                  .then((user) => print(user))
                                  .catchError((e) => print(e)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 210.0,
                            child: ElevatedButton.icon(
                              label: Text(
                                'Login with Facebook',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Image.asset(
                                "assets/facebook.png",
                                width: 24.0,
                                height: 24.0,
                              ),

                              // icon: const Icon(Icons.adjust, size: 28.0,color: Colors.white),
                              onPressed: this._facebookLogin,
                            ),
                          ),
                        ],
                      ),
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

  _navigateRegistration() {
    NavigationRouter.switchToRegistration(context);
  }
}
