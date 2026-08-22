import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_application_1/Widgets/AlertBox.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_erp/apps/flutter_application_1/Widgets/MyAppBar.dart';
import 'package:flutter_erp/apps/flutter_application_1/Widgets/Drawer.dart';
import 'package:flutter_erp/apps/flutter_application_1/Widgets/Heading.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';

// Zahid Ali Regestration Number 2018-CS-136

class ListRecords extends StatefulWidget {
  ListRecords({Key? key}) : super(key: key);

  @override
  _ListRecords createState() => _ListRecords();
}

class _ListRecords extends State<ListRecords> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: DrawerWidget(),
      ),
      // imported from PrimeDetect
      body: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 25,
                ),
                child: Heading(label: "TS Provider"),
              ),
              FutureBuilder<List<Product>>(
                future: products,
                builder: (context, body) {
                  if (body.hasData) {
                    return DataTable(
                      columnSpacing: 10,
                      dataRowHeight: 60,
                      columns: [
                        DataColumn(label: Text("Id")),
                        DataColumn(label: Text("Firstname")),
                        DataColumn(label: Text("Lastname")),
                        DataColumn(label: Text("Gender")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Phone")),
                      ],
                      rows: body.data!
                          .map(
                            ((item) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(item.id)),
                                DataCell(Text(item.firstName)),
                                DataCell(Text(item.lastName)),
                                DataCell(Text(item.gender)),
                                DataCell(
                                  Container(width: 90, child: Text(item.email)),
                                ),
                                DataCell(Text(item.phone)),
                              ],
                            )),
                          )
                          .toList(),
                    );
                  } else if (body.hasError) {
                    return Center(
                      child: AlertBox(message: "tt:${body.error}", path: "/"),
                    );
                  }

                  // By default, it show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Product> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> getProducts() async {
  final response = await HttpClient.get(
    "http://bilalganjmarket.com/apis/persons_list.php",
  );

  if (response.statusCode == 200) {
    // If the server returns an OK response, then parse the JSON.
    // return json.decode(response.body);
    return parseData(response.body!);
  } else {
    // If the response was umexpected, throw an error.
    throw Exception('Failed to load product');
  }
}

class Product {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phone;

  Product({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
