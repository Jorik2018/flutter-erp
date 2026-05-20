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

class UsersFragment extends StatefulWidget {

  LX? mm;

  UsersFragment({this.mm});

  @override
  _UsersFragmentState createState() => _UsersFragmentState();

}

class _UsersFragmentState extends State<UsersFragment> {

  int page = 0;
  int limit = 50;

  Future _getItems(page, limit) async {
    var data = {
      'query': '''
        query{
          users(offset:${page * limit} limit:${limit} roleName:"pma") {
            data{
              uid,
              name,
              directoryId,
              fullName,
              status,
              mail
            }
            size
          }
        }
        '''
    };
    return await http2.gql('/api/admin/graphql', data, state: this);
  }

  @override
  void initState() {
    _selected = List<bool>.generate(0, (int index) => false);
    super.initState();
    Future.delayed(Duration.zero, () {
      reload();
    });
    widget.mm!.observer!('title', 'Usuarios');
  }

  reload() {
    _getItems(page, limit).then((result) {
      List data = result['users']['data'];
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
                        context.go('/user/' + _data[i]['uid'].toString() + '/edit');
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
                )),
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/user/create');
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
                    label: Text('Nombre'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                      label: Text('Correo Electronico'),
                      size: ColumnSize.L,
                      fixedWidth: 200),
                  DataColumn(
                    label: Text('Nombre Completo'),
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
                              DataCell(Text(book['name'] ?? '')),
                              DataCell(Text(book['mail'] ?? '')),
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
    print('dispose users');
  }
}
