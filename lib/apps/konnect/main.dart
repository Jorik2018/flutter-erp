import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/apps/konnect/managers/landing_manger.dart';
import 'package:flutter_erp/apps/konnect/models/konnector.dart';
import 'package:flutter_erp/apps/konnect/screens/auth/auth_page.dart';
import 'package:flutter_erp/apps/konnect/sevices/auth.dart';
import 'package:flutter_erp/apps/konnect/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        Provider<AuthBase>.value(value: Auth()),
        ChangeNotifierProvider<Konnector>.value(value: Konnector()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Konnect',
        theme: ThemeData(
          primaryColor: kColorPrimary,
          brightness: Brightness.dark,
          fontFamily: 'GoogleSans',
        ),
        home: LandingManager(),
        routes: {
          '\main': (ctx) => LandingManager(),
          '\auth': (ctx) => AuthPage(),
        },
      ),
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(
//             height: 200.0,
//           ),
//           Image.asset(
//             'assets/images/logo.png',
//             scale: 5,
//           ),
//           SizedBox(
//             height: 70.0,
//           ),
//           Text(
//             'Konnect',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headline4.copyWith(
//                   color: Colors.white.withOpacity(0.25),
//                   fontWeight: FontWeight.w600,
//                 ),
//           )
//         ],
//       ),
//     );
//   }
// }
