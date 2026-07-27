import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_pma/utils/util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_erp/apps/flutter_pma/utils/redirect_stub.dart' // Stub implementation
    if (dart.library.html) 'package:flutter_erp/apps/flutter_pma/utils/redirect_web.dart'
    if (dart.library.io) 'package:flutter_erp/apps/flutter_pma/utils/redirect_other.dart';

GoRoute OAuthRouter() {
  return GoRoute(
    path: '/oauth',
    builder: (BuildContext context, GoRouterState state) {
      return OAuthScreen(state);
    },
  );
}

class OAuthScreen extends StatefulWidget {
  GoRouterState state;

  OAuthScreen(this.state);

  @override
  _OAuthScreenState createState() => _OAuthScreenState();
}

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}

class _OAuthScreenState extends State<OAuthScreen> {
  String msg = '';

  StreamSubscription? subscription;

  @override
  void dispose() {
    if (subscription != null) subscription!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      subscription = uriLinkStream.listen((Uri? uri) {
        _initToken(uri!.queryParameters['code'].toString());
      }, onError: (Object err) {});
    }
    var code = widget.state.queryParams['code'];
    if (code == null)
      _authorizeCode();
    else {
      _initToken(code);
    }
  }

  void _initToken(String code) {
    setState(() {
      msg = msg + ' code' + code;
    });
    http2
        .post(
          '/api/auth/token',
          code,
          headers: (h) {
            h.clear();
            return h;
          },
        )
        .then((response) {
          var result = jsonDecode(response.body);
          if (result['error'] == null)
            Hive.openBox('app').then((boxApp) {
              boxApp
                  .put('token', result['access_token'] ?? result['token'])
                  .then((value) {
                    boxApp.put('perms', result['perms']);
                    boxApp.put('user_nicename', result['user_nicename']);
                    while (context.canPop()) context.pop();
                    context.go("/");
                  });
            });
        });
  }

  void _authorizeCode() {
    getManager().go(
      Util.API_URL +
          '/api/oauth/authorize?response_type=code&client_id=' +
          dotenv.env['OAUTH_CLIENT_ID']! +
          '&scope=profile',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Text('OAuth->' + msg),
      ),
    );
  }
}
