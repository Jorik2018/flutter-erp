import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'data/model/filter_rules.dart';
import 'data/repositories/abstract/cart_repository.dart';
import 'data/repositories/abstract/category_repository.dart';
import 'data/repositories/abstract/favorites_repository.dart';
import 'data/repositories/abstract/product_repository.dart';
import 'data/repositories/abstract/user_repository.dart';
import 'locator.dart' as service_locator;
import 'presentation/features/authentication/authentication.dart';
import 'presentation/features/cart/cart.dart';
import 'presentation/features/categories/categories.dart';
import 'presentation/features/checkout/checkout.dart';
import 'presentation/features/favorites/favorites.dart';
import 'presentation/features/filters/filters_screen.dart';
import 'presentation/features/forget_password/forget_password.dart';
import 'presentation/features/forget_password/forget_password_screen.dart';
import 'presentation/features/home/home.dart';
import 'presentation/features/product_details/product_screen.dart';
import 'presentation/features/products/products.dart';
import 'presentation/features/profile/profile.dart';
import 'presentation/features/sign_in/sign_in.dart';
import 'presentation/features/sign_in/signin_screen.dart';
import 'presentation/features/sign_up/sign_up_bloc.dart';
import 'presentation/features/sign_up/signup_screen.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    debugPrint('[EVENT] ${bloc.runtimeType}: $event');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);

    debugPrint('[TRANSITION] ${bloc.runtimeType}: $transition');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    debugPrint('[CHANGE] ${bloc.runtimeType}: $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    debugPrint('[ERROR] ${bloc.runtimeType}: $error');

    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  service_locator.init();

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final localizationDelegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: const ['en_US', 'de', 'fr'],
  );

  Bloc.observer = AppBlocObserver();

  runApp(
    LocalizedApp(localizationDelegate, const OpenFlutterEcommerceBootstrap()),
  );
}

class OpenFlutterEcommerceBootstrap extends StatelessWidget {
  const OpenFlutterEcommerceBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (_) => service_locator.sl<CategoryRepository>(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (_) => service_locator.sl<ProductRepository>(),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (_) => service_locator.sl<FavoritesRepository>(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => service_locator.sl<UserRepository>(),
        ),
        RepositoryProvider<CartRepository>(
          create: (_) => service_locator.sl<CartRepository>(),
        ),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc()..add(AppStarted()),
        child: OpenFlutterEcommerceApp(),
      ),
    );
  }
}

class OpenFlutterEcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate,
        ],
        onGenerateRoute: _registerRoutesWithParameters,
        supportedLocales: localizationDelegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: localizationDelegate.currentLocale,
        title: 'Open FLutter E-commerce',
        theme: OpenFlutterEcommerceTheme.of(context),
        routes: _registerRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _registerRoutes() {
    return <String, WidgetBuilder>{
      OpenFlutterEcommerceRoutes.home: (context) => HomeScreen(),
      OpenFlutterEcommerceRoutes.cart: (context) => CartScreen(),
      OpenFlutterEcommerceRoutes.checkout: (context) => CheckoutScreen(),
      OpenFlutterEcommerceRoutes.favourites: (context) => FavouriteScreen(),
      OpenFlutterEcommerceRoutes.signin: (context) => _buildSignInBloc(),
      OpenFlutterEcommerceRoutes.signup: (context) => _buildSignUpBloc(),
      OpenFlutterEcommerceRoutes.forgotPassword: (context) =>
          _buildForgetPasswordBloc(),
      OpenFlutterEcommerceRoutes.profile: (context) =>
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              //TODO: revise authentication later. Right now no login is required.
              /*if (state is Authenticated) {
              return ProfileScreen(); //TODO profile properties should be here
            } else if (state is Unauthenticated) {
              return _buildSignInBloc();
            } else {
              return SplashScreen();
            }*/
              return ProfileScreen();
            },
          ),
    };
  }

  BlocProvider<ForgetPasswordBloc> _buildForgetPasswordBloc() {
    return BlocProvider<ForgetPasswordBloc>(
      create: (context) => ForgetPasswordBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: ForgetPasswordScreen(),
    );
  }

  BlocProvider<SignInBloc> _buildSignInBloc() {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignInScreen(),
    );
  }

  BlocProvider<SignUpBloc> _buildSignUpBloc() {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignUpScreen(),
    );
  }

  Route _registerRoutesWithParameters(RouteSettings settings) {
    final arguments = settings.arguments;
    if (settings.name == OpenFlutterEcommerceRoutes.shop) {
      return MaterialPageRoute(
        builder: (context) {
          return CategoriesScreen(
            parameters: arguments as CategoriesParameters?,
          );
        },
      );
    } else if (settings.name == OpenFlutterEcommerceRoutes.productList) {
      return MaterialPageRoute(
        builder: (context) {
          return ProductsScreen(
            parameters: arguments as ProductListScreenParameters,
          );
        },
      );
    } else if (settings.name == OpenFlutterEcommerceRoutes.product) {
      return MaterialPageRoute(
        builder: (context) {
          return ProductDetailsScreen(arguments as ProductDetailsParameters);
        },
      );
    } else if (settings.name == OpenFlutterEcommerceRoutes.filters) {
      return MaterialPageRoute(
        builder: (context) {
          return FiltersScreen(arguments as FilterRules);
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      );
    }
  }
}
