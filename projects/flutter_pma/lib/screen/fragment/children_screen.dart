//import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:flutter_pma/utils/util.dart';
//https://blog.logrocket.com/flutter-datatable-widget-guide-displaying-data/

class ChildrenScreen extends StatefulWidget {
  LX? mm;

  ChildrenScreen({this.mm});

  @override
  _ChildrenScreenState createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  int page = 0;
  int limit = 50;

  Future _getItems(page, limit) async {
    http.Response? response = await http2.get(
        '/api/minsa/children/' + page.toString() + '/' + limit.toString(),
        state: this);
    try {
      return jsonDecode(response!.body);
    } catch (e) {
      return {'data': [], 'size': 0};
    }
  }

  @override
  void initState() {
    _selected = List<bool>.generate(0, (int index) => false);
    super.initState();
    Future.delayed(Duration.zero, () {
      reload();
    });
    widget.mm!.observer!('title', 'Seguimiento de Niños');
  }

  reload() {
    _getItems(page, limit).then((result) {
      List data = result['data'];
      setState(() {
        _data = data.cast<Map>();
        _selected = List<bool>.generate(data.length, (int index) => false);
      });
    });
  }

  List<Map> _data = [];
  List<bool> _selected = [];

  List<Widget> getActions() {
    return (_selected.length > 0 && _selected.reduce((v, e) => v = (v || e)))
        ? [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    for (int i = 0; i < _selected.length; i++) {
                      if (_selected[i] == true) {
                        context.go(
                            '/children/' + _data[i]['_id']['\$oid'] + '/edit');
                        break;
                      }
                    }
                  },
                  child: Icon(
                    Icons.edit,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.delete,
                  ),
                ))
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/children/create');
          },
          child: Icon(Icons.add),
        ),
        body: Column(children: [
          Row(children: [
            IconButton(
              icon: const Icon(Icons.first_page_rounded),
              onPressed: reload,
            ),
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.last_page_outlined),
              tooltip: 'Increase volume by 10',
              onPressed: () {
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: reload,
            ),
          ]),
          Expanded(
            child: DataTable2(
                columnSpacing: 12,
                headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                headingRowColor:
                    MaterialStateProperty.resolveWith((states) => Colors.black),
                horizontalMargin: 12,
                minWidth: 600,
                columns: [
                  DataColumn2(
                    label: Text('DNI'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                      label: Text('Nombre Completo'),
                      size: ColumnSize.L,
                      fixedWidth: 200),
                  DataColumn(
                    label: Text('Fecha nacimiento / Edad'),
                  ),
                  DataColumn2(
                    label: Text('Distrito'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Dirección'),
                    size: ColumnSize.L,
                  ),
                ],
                rows: _data
                    .mapIndexed((index, book) => DataRow(
                            cells: [
                              DataCell(Text(book['code'] ?? '')),
                              DataCell(Text((book['p2'] ?? '') +
                                  ' ' +
                                  (book['p3'] ?? '') +
                                  ' ' +
                                  (book['p1'] ?? ''))),
                              DataCell(Text(book['birthday'] ?? '')),
                              DataCell(Text(book['p5_9'] ?? '')),
                              DataCell(Text((book['p10'] ?? '') +
                                  ' ' +
                                  (book['p11'] ?? '')))
                            ],
                            selected: _selected[index],
                            onSelectChanged: (bool? selected) {
                              setState(() {
                                _selected[index] = selected!;
                                widget.mm!.observer!('actions', getActions());
                              });
                            }))
                    .toList()),
          )
        ]));
  }

  bool isSelected() {
    return _selected.length > 0 && _selected.reduce((v, e) => v = (v || e));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
