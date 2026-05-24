import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/productapp/core/models/productModel.dart';
import 'package:flutter_erp/apps/productapp/core/viewmodels/CRUDModel.dart';
import 'package:flutter_erp/apps/productapp/ui/widgets/productCard.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Product>? products;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<CRUDModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Center(child: Text('Home')),
      ),
      body: Container(
        /**Couldn't infer type parameter 'T'.

Tried to infer 'List<Product>' for 'T' which doesn't work:
  Parameter 'builder' declared as     'Widget Function(BuildContext, AsyncSnapshot<T>)'
                      but argument is 'StatelessWidget Function(BuildContext, AsyncSnapshot<QuerySnapshot<Object?>>)'.
The type 'List<Product>' was inferred from:
  Parameter 'stream' declared as     'Stream<T>?'
                     but argument is 'Stream<List<Product>>'.

Consider passing explicit type argument(s) to the generic. */
        child: StreamBuilder<List<Product>>(
            stream: productProvider.fetchProductsAsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                products = snapshot.data!;
                return ListView.builder(
                  itemCount: products!.length,
                  itemBuilder: (buildContext, index) =>
                      ProductCard(productDetails: products![index]),
                );
              } else {
                return Text('fetching');
              }
            }),
      ),
    );
    ;
  }
}
