import 'package:flutter/material.dart';
import 'lista_citta.dart';
import 'screen_cerca_biglietto.dart';

class ScreenCitta extends StatefulWidget {
  Citta _citta;

  ScreenCitta(this._citta);

  @override
  State createState() => new ScreenCittaState();
}

class ScreenCittaState extends State<ScreenCitta> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("${widget._citta.nome}"),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search), onPressed: () => null),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, int i) => new TileLuogo(widget._citta.luoghi![i]),
        itemCount: widget._citta.luoghi!.length,
        scrollDirection: Axis.vertical,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          new MaterialPageRoute(builder: (_) => new ScreenCercaBiglietto()),
        ),
        child: Icon(Icons.flight_takeoff),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}

class TileLuogo extends StatefulWidget {
  final Luogo _luogo;
  TileLuogo(this._luogo);

  bool selected = true;

  @override
  State createState() => new TileLuogoState();
}

class TileLuogoState extends State<TileLuogo> {
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => setState(() => widget.selected = !widget.selected),
      onLongPress: () => _longPress(context),
      child: Material(
        elevation: 8.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(new Radius.circular(20.0)),
            image: DecorationImage(
              image: AssetImage(widget._luogo.img!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black45,
                BlendMode.luminosity,
              ),
            ),
          ),
          child: SizedBox.fromSize(
            size: Size.fromHeight(180.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Checkbox(
                      value: widget.selected,
                      onChanged: (bool? newValue) =>
                          setState(() => widget.selected = newValue ?? false),
                    ),
                  ),
                ),
                Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Text(
                      widget._luogo.nome!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _longPress(BuildContext context) {
    showDialog(
      builder: (context) => new SimpleDialog(
        contentPadding: EdgeInsets.all(0.0),
        children: <Widget>[
          new Image.asset(widget._luogo.img!),
          new Text(
            widget._luogo.nome! /*, style: Theme.of(context).textTheme.title*/,
          ),
          new Text(widget._luogo.descrizione!),
          //new Text(_luogo.posizione)
        ],
      ),
      context: context,
    );
  }
}
