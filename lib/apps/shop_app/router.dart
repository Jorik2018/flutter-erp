import 'package:flutter_erp/apps/shop_app/models/Product.dart';
import 'package:flutter_erp/apps/shop_app/screens/cart/cart_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/details/details_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/home/home_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/login_success/login_success_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/otp/otp_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/profile/profile_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/sign_up/sign_up_screen.dart';
import 'package:flutter_erp/apps/shop_app/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Configs {
  static String pathParent = '';
}

RouteBase buildRouter({required String path}) {
  Configs.pathParent = path;

  return GoRoute(
    path: path,
    builder: (_, __) => SplashScreen(),
    routes: [
      GoRoute(path: SignInScreen.routeName, builder: (_, __) => SignInScreen()),
      GoRoute(
        path: ForgotPasswordScreen.routeName,
        builder: (_, __) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: LoginSuccessScreen.routeName,
        builder: (_, __) => LoginSuccessScreen(),
      ),
      GoRoute(path: SignUpScreen.routeName, builder: (_, __) => SignUpScreen()),
      GoRoute(
        path: CompleteProfileScreen.routeName,
        builder: (_, __) => CompleteProfileScreen(),
      ),
      GoRoute(path: OtpScreen.routeName, builder: (_, __) => OtpScreen()),
      GoRoute(path: HomeScreen.routeName, builder: (_, __) => HomeScreen()),
      GoRoute(
        path: DetailsScreen.routeName,
        builder: (context, state) {
          final product = state.extra as Product;

          return DetailsScreen(product: product);
        },
      ),
      GoRoute(path: CartScreen.routeName, builder: (_, __) => CartScreen()),
      GoRoute(
        path: ProfileScreen.routeName,
        builder: (_, __) => ProfileScreen(),
      ),
    ],
  );
}
