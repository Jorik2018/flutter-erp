import 'package:flutter/material.dart';
import 'lista_citta.dart';
import 'screen_citta.dart';

class ListaCittaScreen extends StatelessWidget {
  PageController controller = new PageController();
  Widget build(BuildContext context) {
    return new Scaffold(
      body: PageView.builder(
        itemBuilder: (_, int i) => new CopertinaCitta(ListaCitta.listaCitta[i]),
        itemCount: ListaCitta.listaCitta.length,
        controller: controller,
      ),
    );
  }
}

class CopertinaCitta extends StatelessWidget {
  final Citta citta;

  CopertinaCitta(this.citta);

  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(citta.img!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.luminosity),
        ),
      ),
      child: Stack(
        children: <Widget>[
          new Align(
            alignment: FractionalOffset.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 32.0, left: 24.0, right: 24.0),
              child: Text(
                citta.nome!.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 90.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          new Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(Icons.keyboard_arrow_up, color: Colors.black),
                onPressed: () => Navigator.of(context).push(
                  new MaterialPageRoute(builder: (_) => new ScreenCitta(citta)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
