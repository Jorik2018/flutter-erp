import 'dart:async';
import 'dart:convert';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';
import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = AsyncNotifierProvider<AuthController, app_user.User?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<app_user.User?> {
  static const _userKey = 'current_user';

  final List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late SharedPreferences prefs;

  GoogleSignInAccount? _currentUser;

  bool _googleSignInInitialized = false;

  @override
  Future<app_user.User?> build() async {
    //await _initializeGoogleSignIn();

    // Aquí también podrías comprobar:
    // - una sesión guardada de tu API
    // - FirebaseAuth.currentUser
    // - una sesión ligera de Google
    final prefs = await SharedPreferences.getInstance();

    final jsonUser = prefs.getString(_userKey);

    if (jsonUser == null) {
      return null;
    }
    try {
      return app_user.User.fromJson(
        jsonDecode(jsonUser) as Map<String, dynamic>,
      );
    } catch (_) {
      // Si quedó basura/corrupto en SharedPreferences,
      // eliminamos la sesión.
      await prefs.remove(_userKey);
      return null;
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    if (_googleSignInInitialized) {
      return;
    }

    unawaited(
      _googleSignIn
          .initialize(
            // En Android normalmente puede obtenerse desde google-services.json.
            // clientId: 'CLIENT_ID',

            // Necesario principalmente si enviarás el token a un backend.
            // serverClientId: 'WEB_CLIENT_ID',
          )
          .then((_) {
            _googleSignIn.authenticationEvents.listen(
              _handleAuthenticationEvent,
            )
            //.onError(_handleAuthenticationError)
            ;

            /// This example always uses the stream-based approach to determining
            /// which UI state to show, rather than using the future returned here,
            /// if any, to conditionally skip directly to the signed-in state.
            _googleSignIn.attemptLightweightAuthentication();
          }),
    );

    _googleSignInInitialized = true;
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization
    /*GoogleSignInAccount googleUser = await googleSignIn.googleSignIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? firebaseUser = (await firebaseAuth.signInWithCredential(
      credential,
    )).user;

    if (firebaseUser != null) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
              'nickname': firebaseUser.displayName,
              'photoUrl': firebaseUser.photoURL,
              'id': firebaseUser.uid,
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              'chattingWith': null,
            });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser!.uid);
        await prefs.setString('nickname', currentUser!.displayName!);
        await prefs.setString('photoUrl', currentUser!.photoURL!);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(currentUserId: firebaseUser.uid),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }*/
    /*setState(() {
      _currentUser = user;
      _isAuthorized = authorization != null;
      _errorMessage = '';
    });*/

    // If the user has already granted access to the required scopes, call the
    // REST API.
    /*if (user != null && authorization != null) {
      unawaited(_handleGetContact(user));
    }*/
  }

  Future<void> login({required String name, required String pass}) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final normalizedName = name.trim();

      if (normalizedName.isEmpty) {
        throw const AuthException('Ingresa el usuario');
      }

      if (pass.isEmpty) {
        throw const AuthException('Ingresa la contraseña');
      }

      // Sustituir por tu API REST, Firebase, Appwrite, etc.
      await Future<void>.delayed(const Duration(seconds: 1));

      final user = app_user.User(name: normalizedName, id: '123');
      // Si las credenciales no son válidas:
      //
      // throw const AuthException(
      //   'Usuario o contraseña incorrectos',
      // );
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setString(_userKey, jsonEncode(user.toJson())),
      );
      return user;
    });
  }

  Future<void> loginWithGoogle() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _initializeGoogleSignIn();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw const AuthException(
          'Google Sign-In no está disponible en esta plataforma.',
        );
      }

      try {
        final GoogleSignInAccount account = await _googleSignIn.authenticate();

        // Aquí puedes guardar o enviar estos datos a tu backend:
        final String id = account.id;
        final String email = account.email;
        final String? name = account.displayName;
        final String? photoUrl = account.photoUrl;

        // Evita warnings mientras todavía no usas estos datos.
        /*_ = id;
        _ = email;
        _ = name;
        _ = photoUrl;
*/
        return null;
      } on GoogleSignInException catch (error) {
        if (error.code == GoogleSignInExceptionCode.canceled) {
          throw const AuthCancelledException('Inicio de sesión cancelado.');
        }

        throw AuthException(
          error.description ?? 'No se pudo iniciar sesión con Google.',
        );
      }
    });
  }

  Future<void> logout() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _initializeGoogleSignIn();

      // Cierra la sesión de Google si existe.
      await _googleSignIn.signOut();

      // También puedes cerrar aquí la sesión de tu API:
      // await authRepository.logout();

      return null;
    });
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    /*setState(() {
      _contactText = 'Loading contact info...';
    });*/
    final Map<String, String>? headers = await user.authorizationClient
        .authorizationHeaders(scopes);
    if (headers == null) {
      /*setState(() {
        _contactText = '';
        _errorMessage = 'Failed to construct authorization headers.';
      });*/
      return;
    }
    final HttpResponse response = await HttpClient.get(
      'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names',
      headers: headers,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        /*setState(() {
          _errorMessage =
              'People API gave a ${response.statusCode} response. '
              'Please re-authorize access.';
        });*/
      } else {
        print('People API ${response.statusCode} response: ${response.body}');
        /*setState(() {
          _contactText =
              'People API gave a ${response.statusCode} '
              'response. Check logs for details.';
        });*/
      }
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body!) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    /*setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });*/
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact =
        connections?.firstWhere(
              (dynamic contact) =>
                  (contact as Map<Object?, dynamic>)['names'] != null,
              orElse: () => null,
            )
            as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name =
          names.firstWhere(
                (dynamic name) =>
                    (name as Map<Object?, dynamic>)['displayName'] != null,
                orElse: () => null,
              )
              as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthCancelledException extends AuthException {
  const AuthCancelledException(super.message);
}
