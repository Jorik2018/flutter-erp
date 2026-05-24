import 'package:flutter/material.dart' hide Router;
import 'package:provider/provider.dart';
import 'ui/router.dart';
import 'locator.dart';
import 'core/viewmodels/CRUDModel.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /**The named parameter 'create' is required, but there's no corresponding argument.
Try adding the required argument. */
        ChangeNotifierProvider(create: (_) => locator<CRUDModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        title: 'Product App',
        theme: ThemeData(),
        /**The name 'Router' is defined in the libraries 'package:flutter/src/widgets/router.dart (via package:flutter/material.dart)' and 'package:flutter_erp/apps/productapp/ui/router.dart'.
Try using 'as prefix' for one of the import directives, or hiding the name from all but one of the imports. */
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
