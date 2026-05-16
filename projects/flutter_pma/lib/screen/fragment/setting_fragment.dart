import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../utils/util.dart';

class SettingFragment extends StatefulWidget {
  LX? mm;

  SettingFragment({super.key, this.mm});

  @override
  _SettingFragmentState createState() => new _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  FormBuilder fb = FormBuilder({});
  ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(16.0),
      primary: Colors.white,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(fontSize: 20));

  _reload(id) {
    /*http2.get('/api/minsa/children/${widget.id}').then((response) {
      var data = jsonDecode(response!.body);
      if (data['province'] != null) {
        _getDistricts(data['province']).then((result) => {
              setState(() {
                districts = (result['data'] as List).toList();
                fb.o = data;
              })
            });
      }
      if (data['region'] != null) {
        _getProvinces(data['region']).then((result) => {
              setState(() {
                provinces = (result['data'] as List).toList();
                fb.o = data;
              })
            });
      } else
        setState(() {
          fb.o = data;
        });
    });*/
  }

  @override
  void initState() {
    super.initState();
    print('initState setting_fragment');
    Future.delayed(Duration.zero, () {
      Hive.openBox('app').then((box) {
        fb.o = (box.get('config') ?? {});
        fb.expanded[0] = true;
        var data = box.get('regions');
        if (data == null) {
          _getRegions().then((data) {
            setState(() {
              box.put("regions", regions = data);
            });
          });
        } else
          regions = data;
        data = box.get('provinces');
        if (data == null) {
          _getProvinces().then((data) {
            setState(() {
              box.put("provinces", provinces = data);
            });
          });
        } else {
          provinces = (data as List)
              .where((element) => element['code']
                  .toString()
                  .startsWith((fb.o['region'] ?? '99').toString()))
              .toList();
        }
        data = box.get("districts");
        if (data == null) {
          _getDistricts().then((data) {
            setState(() {
              box.put("districts", districts = data);
            });
          });
        } else {
          districts = (data as List)
              .where((element) => element['code']
                  .toString()
                  .startsWith((fb.o['province'] ?? '99').toString()))
              .toList();
        }
        setState(() {});
      });
    });
    fb.expanded[0] = true;
    if (widget.mm != null) widget.mm!.observer!('title', "Configuración");
  }

  @override
  void dispose() {
    widget.mm!.observer!('title', null);
    super.dispose();
  }

  Future _getRegions() async {
    http.Response? response = await http2.get(
        'http://web.regionancash.gob.pe/admin/directory/api/region/0/0',
        headers: {});
    return (response != null ? jsonDecode(response.body)['data'] : []);
  }

  Future _getProvinces([Object? regionId]) async {
    http.Response? response = await http2.get(
        'http://web.regionancash.gob.pe/admin/directory/api/province/0/0',
        headers: {});
    return (response != null ? jsonDecode(response.body)['data'] : []);
  }

  Future _getDistricts([Object? regionId]) async {
    http.Response? response = await http2.get(
        'http://web.regionancash.gob.pe/admin/directory/api/district/0/0',
        headers: {});
    return (response != null ? jsonDecode(response.body)['data'] : []);
  }

  List regions = [];

  List provinces = [];

  List districts = [];

  @override
  Widget build(BuildContext context) {
    fb.setState = setState;
    List panels = [
      {
        'title': 'Juridicción por defecto',
        'items': [
          Text("Región", style: boldStyle),
          fb.dropdownButton(
              ['--Seleccionar Opción--', ...regions], 'region', setState,
              adapter: (item) {
            item = item as Map;
            return [item['code'], item['name']];
          }, onChanged: (e) {
            Hive.openBox('app').then((box) {
              provinces = (box.get('provinces') as List)
                  .where((element) => element['code']
                      .toString()
                      .startsWith((e != null ? e : '99').toString()))
                  .toList();
              setState(() {});
            });
          }),
          if (fb.o['region'] != null) ...[
            Text("Provincia", style: boldStyle),
            fb.dropdownButton(
                ['--Seleccionar Opción--', ...provinces], 'province', setState,
                adapter: (item) {
              item = item as Map;
              return [item['code'], item['name']];
            }, onChanged: (e) {
              Hive.openBox('app').then((box) {
                districts = (box.get('districts') as List)
                    .where((element) => element['code']
                        .toString()
                        .startsWith((e != null ? e : '99').toString()))
                    .toList();
                setState(() {});
              });
            }),
            if (fb.o['province'] != null) ...[
              Text("Distrito", style: boldStyle),
              fb.dropdownButton(['--Seleccionar Opción--', ...districts],
                  'district', setState, adapter: (item) {
                item = item as Map;
                return [item['name'], item['name']];
              })
            ]
          ]
        ]
      }
    ];

    return new Scaffold(
      /*appBar: new AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: new Text('Configuración'),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 5.0,
      ),*/
      body: Form(
          key: _formKey,
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionPanelList(
                            animationDuration: Duration(milliseconds: 300),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                fb.expanded[index] = !isExpanded;
                              });
                            },
                            children: [...fb.expansionPanel(panels)])
                      ])),
            )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        }
                        Hive.openBox('app').then((box) {
                          box.put('config', fb.o);
                          fb.showSnackBar(context, "Configuracion grabada!");
                        });
                      },
                      label: const Text('Grabar'),
                      icon: Icon(Icons.save))
                ]))
          ])),
    );
  }
}
