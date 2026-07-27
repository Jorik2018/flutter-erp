import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_ecommerce_app/common_widget/AppBarWidget.dart';
import 'package:flutter_erp/apps/flutter_ecommerce_app/common_widget/CircularProgress.dart';
import 'package:flutter_erp/apps/flutter_ecommerce_app/models/ProductDetails.dart';
import 'package:flutter_erp/apps/flutter_ecommerce_app/utils/Urls.dart';
import 'package:flutter_erp/apps/wonders/logic/common/http_client.dart';

ProductDetails? productDetails;

class ProductDetailScreen extends StatefulWidget {
  String slug;

  ProductDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

//https://api.evaly.com.bd/core/public/products/leather-backpack-for-women-6dba2a50d/
//https://api.evaly.com.bd/core/public/products/special-women-kids-cotton-panjabi-kameez-by-swapons-world-combo-pack-c8648f9f9/

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: appBarWidget(context),
      body: FutureBuilder(
        future: getDetailData(widget.slug),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgress();
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return createDetailView(context, snapshot);
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Row(
        children: <Widget>[
          Icon(Icons.favorite_border, color: Color(0xFF5e5e5e)),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFfef2f2),
              foregroundColor: const Color(0xFFff665e), // color del texto
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                side: BorderSide(color: Color(0xFFfef2f2)),
              ),
            ),
            child: const Text(
              "ADD TO CART",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFff665e), // antes "color"
              foregroundColor: Colors.white, // antes "textColor"
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                side: BorderSide(color: Color(0xFFff665e)),
              ),
            ),
            child: Text(
              "AVAILABLE AT SHOPS",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

Widget createDetailView(BuildContext context, AsyncSnapshot snapshot) {
  ProductDetails values = snapshot.data;
  return DetailScreen(productDetails: values);
}

class DetailScreen extends StatefulWidget {
  ProductDetails productDetails;

  DetailScreen({Key? key, required this.productDetails}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
          Image.network(
            widget.productDetails.data!.productVariants[0].productImages[0],
            fit: BoxFit.fill,
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;

                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "SKU".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF565656),
                  ),
                ),
                Text(
                  widget.productDetails.data!.productVariants[0].sku,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFfd0100),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Color(0xFF999999)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Price".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF565656),
                  ),
                ),
                Text(
                  "৳ ${(widget.productDetails.data!.productVariants[0].maxPrice != null) ? widget.productDetails.data!.productVariants[0].maxPrice : "Unavailable"}"
                      .toUpperCase(),
                  style: TextStyle(
                    color:
                        (widget
                                .productDetails
                                .data!
                                .productVariants[0]
                                .maxPrice !=
                            null)
                        ? Color(0xFFf67426)
                        : Color(0xFF0dc2cd),
                    fontFamily: 'Roboto-Light.ttf',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Description",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF565656),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "${widget.productDetails.data!.productVariants[0].productDescription}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4c4c4c),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Specification",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF565656),
                  ),
                ),
                SizedBox(height: 15),
                Column(children: generateProductSpecification(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateProductSpecification(BuildContext context) {
    List<Widget> list = [];
    int count = 0;
    widget.productDetails.data!.productSpecifications.forEach((specification) {
      Widget element = Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              specification.specificationName,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF444444),
              ),
            ),
            Text(
              specification.specificationValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF212121),
              ),
            ),
          ],
        ),
      );
      list.add(element);
      count++;
    });
    return list;
  }
}

Future<ProductDetails?> getDetailData(String slug) async {
  HttpResponse response = await HttpClient.get(Urls.ROOT_URL + slug);
  int statusCode = response.statusCode;
  final body = json.decode(response.body!);
  if (statusCode == 200) {
    productDetails = ProductDetails.fromJson(body);
    return productDetails;
  } else {
    return productDetails = ProductDetails();
  }
}
