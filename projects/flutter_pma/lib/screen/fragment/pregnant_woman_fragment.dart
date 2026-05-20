import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:flutter_pma/utils/util.dart';

class PregnantWomanFragment extends StatefulWidget {

  Function? navigateTo;

  String? id;

  LX? mm;

  PregnantWomanFragment({super.key, this.navigateTo, this.id, this.mm});

  @override
  _PregnantWomanFragmentState createState() => _PregnantWomanFragmentState();
  
}

class _PregnantWomanFragmentState extends State<PregnantWomanFragment> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);
  FormBuilder fb = FormBuilder({'p72': '2023-12-12'});

  ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(16.0),
      primary: Colors.white,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(fontSize: 20));

  Position? _position;

  _reload(id) {
    http2.get('/api/minsa/pregnant-woman/$id',state: this).then((response) {
      if(response!=null){
        var data = jsonDecode(response!.body);
        fb.o = data;
        fb.expanded[0] = true;
      setState(() {
        fb.o = {'region': '02'};
        fb.expanded[0] = true;
        Hive.openBox('app').then((box) {
          var config=box.get('config');
          if(config!=null){
            fb.o['region']=config['region']??'02';
            setState(() {});
          }
        });
      });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('initState pregnant_woman_fragment');
    fb.setState = setState;
    if (widget.id != null) {
      Future.delayed(Duration.zero, () {
              _getRegions().then((data) {
        setState(() {
          regions = data;
        });
      });
        _reload(widget.id);
      });
    } else {
      fb.o = {'p5_7': '02'};
      fb.expanded[0] = true;
    }
    if (widget.mm != null) widget.mm!.observer!('appBar', false);
  }

  _getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      Map<String, dynamic> location = {
        'type': 'Point',
        'coordinates': [position.longitude, position.latitude]
      };
      fb.o['location'] = location;
    });
  }

  @override
  void dispose() {
    widget.mm!.observer!('appBar', null);
    super.dispose();
  }

  Future _getRegions() async {
    return ((await Hive.openBox('app')).get('regions') ?? []);
  }

  Future _getProvinces(Object region) async {
    return (((await Hive.openBox('app')).get('provinces') ?? []) as List)
    .where((element) => element['code'].toString().startsWith(region.toString())).toList();
  }

  Future _getDistricts(Object province) async {
    return (((await Hive.openBox('app')).get('districts') ?? []) as List)
      .where((element) => element['code'].toString().startsWith(province.toString())).toList();
  }

  List regions = [];

  List provinces = [];

  List districts = [];

  void onPressedCode() {
    http2.post('/api/reniec/', {'dni': fb.o['code']}).then((response) {
      var result = jsonDecode(response.body);
      var datosPersona = result['datosPersona'];
      setState(() {
        fb.o['names'] = datosPersona['prenombres'];
        fb.o['firstSurname'] = datosPersona['apPrimer'];
        fb.o['lastSurname'] = datosPersona['apSegundo'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    fb.setState = setState;
    String? code = fb.o['code'];
    List panels = [
      {
        'title': 'Información Inicial',
        'items': [
          Label("Fecha:"),
          fb.dateField(context, 'startDate'),
          Label("DNI:"),
          fb.numberField(
            'code',
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                suffixIcon: code != null && code.length >= 8
                    ? IconButton(
                        onPressed: onPressedCode,
                        icon: Icon(Icons.refresh),
                      )
                    : null),
          ),
          Label("Nombre:"),
          fb.textField('names'),
          Label("Apellido paterno:"),
          fb.textField('firstSurname'),
          Label("Apellido materno:"),
          fb.textField('lastSurname'),
          Label("Semana de gestación:"),
          fb.numberField('p3',
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.onetwothree),
                hintText: "Ingrese valor de 1 a 41",
              ),
              min: 1,
              max: 41),
          Label("Número de celular:"),
          fb.numberField('phone',
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: "Ingrese numero celular",
              )),
              Text("Región", style: boldStyle),
          fb.dropdownButton(
              ['--Seleccionar Opción--', ...regions], 'region', setState,
              adapter: (item) {
            item = item as Map;
            return [item['code'], item['name']];
          }, onChanged: (e) {
            _getProvinces(e != null ? e : '99').then((result) => {
                  setState(() {
                    provinces = (result as List).toList();
                  })
                });
          }),
          Text("Geolocalización:", style: boldStyle),
          // ignore: prefer_interpolation_to_compose_strings
          fb.textField('location',
              adapter: (v) {
                return v['coordinates'].toString();
              },
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                var o = fb.o['location']['coordinates'];
                context.push('/map/' + o[0].toString() + '/' + o[1].toString());
              }),
          Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(children: [
                const Spacer(),
                ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    label: const Text('Obtener Coordenadas'),
                    icon: Icon(Icons.save))
              ]))
        ]
      },
      {
        'title': 'Asistencia a Control Prenatal',
        'items': [
          Label("¿Asistió al control CRED que le correspondía?"),
          Text("Según tarjeta de control prenatal"),
          Column(children: fb.radioGroup(["Si", "No"], 'p5', setState)),
          Label(
              "¿Cuenta con las vacunas completas, según su edad gestacional?"),
          Text("Según tarjeta de control prenatal"),
          Column(children: fb.radioGroup(["Si", "No"], 'p6', setState)),
        ]
      },
      {
        'title': 'Suplemento de Hierro',
        'items': [
          Label(
              "¿Cuenta con el suplemento de hierro? (Recibido del esstablecimiento de salud, comparado o donado)"),
          Column(children: fb.radioGroup(["Si", "No"], 'p7', setState)),
          if (fb.o['p7'] == 'Si') ...[
            Label("¿Consume el suplemento de hierro?"),
            Column(children: fb.radioGroup(["Si", "No"], 'p7_a', setState)),
            if (fb.o['p7_a'] == 'No') ...[
              Label(
                  "Si no está consumiendo el suplemento de hierro, ¿Por qué no lo consume?"),
              ...fb.checkboxGroup([
                'Le ha generado molestias (diarrea, estreñimiento, vómitos, tinción de dientes, otros)',
                'Desconfía del suplemento',
                'No le gusta el sabor',
                'Se le olvidó'
              ], 'p7_b_'),
            ]
          ]
        ]
      },
      {
        'title': 'Signos de alarma',
        'items': [
          Label("¿Ha identificado algún signo de alarma"),
          ...fb.checkboxGroup([
            'Náuseas y vómitos prsistentes',
            'Visión borrosa y/o zumbido de oídos',
            'Fiebre/escalofríos',
            'Mareos, desmayos, convulsiones',
            'Dolor/ardor al orinar',
            'Dolor de cabeza',
            'Sangrado vaginal',
            'Hinchazón de cara, manos y/o pies',
            'Pérdida de líquido',
            'Disminución o ausencia de movimiento del bebé',
            'Contracciones antes de las 37 semanas',
            'Ninguna'
          ], 'p8_')
        ]
      },
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.id == null
            ? 'Nueva Ficha de Gestante'
            : 'Editar Ficha Gestante'),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 5.0,
      ),
      body: new Form(
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
                        
                          http2
                              .post('/api/minsa/pregnant-woman', fb,
                                  state: this)
                              .then((response) {
                                setState(() {
                            var result = json.decode(response.body);
                            if (fb.o['_id'] == null) {
                              if (result['_id'] != null){
                                context.replace(
                                    '${'/pregnant-woman/' + result['_id']['\$oid']}/edit');
                                    widget.mm!.observer!('appBar', false);
                              }else
                                context.replace('/pregnant-woman');
                            }
                          });
                        });
                      },
                      label: const Text('Grabar'),
                      icon: Icon(Icons.save))
                ]))
          ])),
    );
  }
}
