import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'login_page.dart';

class Tariffs extends StatefulWidget {
  @override
  State createState() => TariffState();
}

class TariffState extends State<Tariffs> with SingleTickerProviderStateMixin {
  final CollectionReference<Map<String, dynamic>> colRef = FirebaseFirestore
      .instance
      .collection('tariffs');
  final PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initConnectivity();
    return Scaffold(
      appBar: AppBar(title: Text("Тарифы")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        /**The argument type 'Stream<QuerySnapshot<Object?>>' can't be assigned to the parameter type 'Stream<QuerySnapshot<Map<String, dynamic>>>?' */
        stream: colRef.snapshots(),
        builder: (context, snapshot) {
          if (!hasConnection) {
            return Center(
              child: Text(
                'Проверьте подключение к сети',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 1.0,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          return Stack(
            children: <Widget>[
              PageView.builder(
                controller: pageController,
                physics: AlwaysScrollableScrollPhysics(),
                /**The property 'docs' can't be unconditionally accessed because the receiver can be 'null'.
Try making the access conditional (using '?.') or adding a null check to the target ('!'). */
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40.0,
                      horizontal: 30.0,
                    ),
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text(
                        " ${ds['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.amber[900],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Image(
                        image: AssetImage('assets/taksi_econom.png'),
                        height: 70.0,
                      ),
                      SizedBox(height: 50.0),
                      Text(
                        "•  ${ds['cars']}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "•  ${ds['min']}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "• ${ds['one_km']}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "•  ${ds['waiting']}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  );
                },
              ),
              CircleIndicator(
                pageController: pageController,
                size: snapshot.data!.docs.length,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CircleIndicator extends StatefulWidget {
  CircleIndicator({Key? key, this.pageController, this.size}) : super(key: key);
  final PageController? pageController;
  final int? size;
  @override
  State createState() {
    return CircleIndicatorState(pageController, size);
  }
}

class CircleIndicatorState extends State {
  int position = 0;
  int? length;
  CircleIndicatorState(PageController? pageController, int? size) {
    length = size;
    pageController!.addListener(() {
      if (pageController.page!.toInt() != position) {
        setState(() {
          position = pageController.page!.toInt();
          length = size;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicatorList(length!),
      ),
    );
  }

  List<Widget> indicatorList(int size) {
    return List.generate(
      size,
      (i) => i == position
          ? drawCircle(Colors.grey[300]!)
          : drawCircle(Colors.white),
    );
  }

  Widget drawCircle(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      width: 13.0,
      height: 13.0,
    );
  }
}
