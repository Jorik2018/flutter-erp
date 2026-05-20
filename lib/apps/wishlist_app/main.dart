import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'models/item.dart';
import 'pages/add_item/add_item_page.dart';
import 'pages/add_item/add_item_view_model.dart';
import 'pages/edit_item/edit_item_page.dart';
import 'pages/edit_item/edit_item_view_model.dart';
import 'pages/landing/landing_page.dart';
import 'pages/landing/landing_view_model.dart';
import 'pages/wishlist/wishlist_page.dart';
import 'pages/wishlist/wishlist_view_model.dart';
import 'services/wishlist_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: determine initial route based on if user signed in before
  final String initialRoute = LandingPage.route;
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<WishlistService>(
          create: (_) => WishlistService(),
        ),
        ChangeNotifierProvider<LandingViewModel>(
          create: (BuildContext context) => LandingViewModel(),
        ),
        ChangeNotifierProvider<WishlistViewModel>(
          create: (BuildContext context) {
            return WishlistViewModel(
                Provider.of<WishlistService>(context, listen: false));
          },
        ),
        ChangeNotifierProvider<AddItemViewModel>(
          create: (BuildContext context) {
            return AddItemViewModel(
                Provider.of<WishlistService>(context, listen: false));
          },
        ),
        ChangeNotifierProvider<EditItemViewModel>(
          create: (BuildContext context) {
            return EditItemViewModel(
                Provider.of<WishlistService>(context, listen: false));
          },
        ),
      ],
      child: MyApp(initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp(
    this.initialRoute, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishlist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LandingPage.route:
            return MaterialPageRoute(
              builder: (_) => Consumer<LandingViewModel>(
                builder: (_, LandingViewModel viewModel, __) =>
                    LandingPage(viewModel),
              ),
            );
          case WishlistPage.route:
            return MaterialPageRoute(
              builder: (_) => Consumer<WishlistViewModel>(
                builder: (_, WishlistViewModel viewModel, __) =>
                    WishlistPage(viewModel),
              ),
            );
          case AddItemPage.route:
            return MaterialPageRoute(
              builder: (_) => Consumer<AddItemViewModel>(
                builder: (_, AddItemViewModel viewModel, __) =>
                    AddItemPage(viewModel),
              ),
            );
          case EditItemPage.route:
            final Item item = settings.arguments as Item;
            return MaterialPageRoute(
              builder: (_) => Consumer<EditItemViewModel>(
                builder: (_, EditItemViewModel viewModel, __) =>
                    EditItemPage(item, viewModel),
              ),
            );
        }
        return null;
      },
    );
  }
}