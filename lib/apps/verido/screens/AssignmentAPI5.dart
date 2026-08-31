import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/verido/Widgets/Card.dart';
import 'package:flutter_erp/apps/verido/Widgets/Drawer.dart';
import 'package:flutter_erp/apps/verido/Widgets/MyAppBar.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';

class Assignment5 extends StatefulWidget {
  const Assignment5({super.key});

  @override
  State<Assignment5> createState() => _Assignment5State();
}

class _Assignment5State extends State<Assignment5> {
  late Future<List<Product>> productsFuture;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    productsFuture = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final loadedProducts = await getProducts();

    products = loadedProducts;

    return loadedProducts;
  }

  Future<bool> _confirmDelete() async {
    final ConfirmAction? action = await showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete This Card?'),
          content: const Text('This will delete the card from today\'s list.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(ConfirmAction.cancel);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(ConfirmAction.accept);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return action == ConfirmAction.accept;
  }

  void _deleteProduct(Product product) {
    setState(() {
      products.removeWhere((item) => item.id == product.id);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.title} deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.65,
        child: DrawerWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Dismissible(
                    key: ValueKey(product.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) => _confirmDelete(),
                    onDismissed: (_) {
                      _deleteProduct(product);
                    },
                    background: Container(
                      color: Colors.red.shade300,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: MyCard(
                      title: product.title,
                      description: product.description,
                      image: 'lib/assets/smash3.jpg',
                    ),
                  );
                },
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

enum ConfirmAction { cancel, accept }

List<Product> parseData(String responseBody) {
  final List<dynamic> parsed = jsonDecode(responseBody) as List<dynamic>;

  return parsed
      .map((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<Product>> getProducts() async {
  final response = await HttpClient.get(
    'https://my-json-server.typicode.com/zahidalidev/fakeProduct/products',
  );

  if (response.statusCode == 200 && response.body != null) {
    return parseData(response.body!);
  }

  throw Exception(
    'Failed to load products. Status code: ${response.statusCode}',
  );
}

class Product {
  final int id;
  final String title;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
