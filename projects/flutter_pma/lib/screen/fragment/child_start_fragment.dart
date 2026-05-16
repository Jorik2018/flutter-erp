import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pma/utils/util.dart';

class ChildStartFragment extends StatefulWidget {
  Function? navigateTo;

  String? id;

  LX? mm;

  ChildStartFragment({this.navigateTo, this.id, this.mm});

  @override
  _ChildStartFragmentState createState() => new _ChildStartFragmentState();
}

FormBuilder fb = FormBuilder({'p72': '2023-12-12'});

class _ChildStartFragmentState extends State<ChildStartFragment> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();

  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(16.0),
      primary: Colors.white,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(fontSize: 20));

  FormBuilder fb = FormBuilder({'p72': '2023-12-12'});

  Position? _position;

  List regions = [];

  List provinces = [];

  List districts = [];

  _reload(id) {
    http2.get('/api/minsa/children/${widget.id}', state: this).then((response) {
      if (response != null) {
        var data = jsonDecode(response!.body);
        fb.o = data;
        fb.expanded[0] = true;
        Hive.openBox('app').then((box) {
          if (fb.o['region'] != null) {
            provinces = ((box.get("provinces") ?? []) as List)
                .where((element) =>
                    element['code'].toString().startsWith(fb.o['region']))
                .toList();
          }
          if (fb.o['province'] != null) {
            districts = ((box.get("districts") ?? []) as List)
                .where((element) =>
                    element['code'].toString().startsWith(fb.o['province']))
                .toList();
          }
          setState(() {});
        });
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getRegions().then((data) {
        setState(() {
          regions = data;
        });
      });
      if (widget.id != null) {
        _reload(widget.id);
      } else {
        fb.o = {'region': '02'};
        fb.expanded[0] = true;
        Hive.openBox('app').then((box) {
          var config = box.get('config');
          if (config != null) {
            fb.o['region'] = config['region'] ?? '02';
            setState(() {});
          }
          _getProvinces(fb.o['region']).then((result) => {
                setState(() {
                  provinces = (result as List).toList();
                })
              });
        });
      }
    });
    if (widget.mm != null) {
      widget.mm!.observer!('appBar', false);
    }
  }

  @override
  void dispose() {
    widget.mm!.observer!('appBar', null);
    super.dispose();
  }

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

  Future _getRegions() async {
    return ((await Hive.openBox('app')).get('regions') ?? []);
  }

  Future _getProvinces(Object region) async {
    return (((await Hive.openBox('app')).get('provinces') ?? []) as List)
        .where((element) =>
            element['code'].toString().startsWith(region.toString()))
        .toList();
  }

  Future _getDistricts(Object province) async {
    return (((await Hive.openBox('app')).get('districts') ?? []) as List)
        .where((element) =>
            element['code'].toString().startsWith(province.toString()))
        .toList();
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
  Widget build(BuildContext context) {
    fb.setState = setState;
    String? code = fb.o['code'];
    List panels = [
      {
        'title': 'Datos personales del niño o niña',
        'items': [
          Label("DNI/partida de nacimiento/CUI"),
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
          Text("Nombre del niño/a", style: boldStyle),
          fb.textField('p1'),
          Text("Apellido paterno:", style: boldStyle),
          Row(children: <Widget>[
            Expanded(child: fb.textField('p2')),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    /// _isEnable = true;
                  });
                })
          ]),
          Text("Apellido materno", style: boldStyle),
          fb.textField('p3'),
          Text("Sexo", style: boldStyle),
          Column(
              children:
                  fb.radioGroup(['Masculino', 'Femenino'], 'p4', setState)),
          Text("Fecha nacimiento", style: boldStyle),
          fb.dateField(context, 'birthday'),
          Text("Tipo de seguro al que se encuentra afiliado/a",
              style: boldStyle),
          Column(
              children: fb.radioGroup([
            'SIS',
            'ESSALUD',
            'FAP',
            'PNP',
            'Privado',
            'No tiene seguro'
          ], 'insuranceType', setState)),
          Text("Geolocalización:", style: boldStyle),
          // ignore: prefer_interpolation_to_compose_strings
          fb.textField('location',
              adapter: (v) {
                return v['coordinates'].toString();
              },
              textAlign: TextAlign.center,
              placeholder: '',
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
              ])),
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
          if (fb.o['region'] != null && fb.o['region'] != '') ...[
            Text("Provincia", style: boldStyle),
            fb.dropdownButton(
                ['--Seleccionar Opción--', ...provinces], 'province', setState,
                adapter: (item) {
              item = item as Map;
              return [item['code'], item['name']];
            }, onChanged: (e) {
              _getDistricts(e != null ? e : '99').then((result) => {
                    setState(() {
                      districts = (result as List).toList();
                    })
                  });
            }),
            if (fb.o['province'] != null) ...[
              Text("Distrito", style: boldStyle),
              fb.dropdownButton(
                  ['--Seleccionar Opción--', ...districts], 'p5_9', setState,
                  adapter: (item) {
                item = item as Map;
                return [item['name'], item['name']];
              })
            ]
          ]
        ]
      },
      {
        'title': 'Ubicación de la vivienda',
        'items': [
          Label("Eje Vial:"),
          Column(
              children: fb.radioGroup(
                  ['Avenida', 'Calle', 'Jirón', 'Sin eje vial'],
                  'p9',
                  setState)),
          Label("Dirección Actual:"),
          fb.textField('p10'),
          Label("Referencia de la Dirección:"),
          fb.textField('p11'),
          Row(
            children: <Widget>[
              Expanded(child: Text("Corregir Información")),
              Switch(
                value: fb.vars['change-location'] != null &&
                    fb.vars['change-location'] == true,
                onChanged: (b) {
                  setState(() {
                    fb.vars['change-location'] == b;
                  });
                },
              ),
            ],
          )
        ]
      },
      {
        'title': 'Datos de la madre, padre o cuidador/a',
        'items': [
          Label("Nombres del padre:"),
          fb.textField('p13'),
          Label("Apellido paterno del padre:"),
          fb.textField('p14'),
          Label("Apellido materno del padre:"),
          fb.textField('p15'),
          Label("DNI del padre:"),
          fb.numberField('p16'),
          Label("Nombres de la madre:"),
          fb.textField('p17'),
          Label("Apellido paterno de la madre"),
          fb.textField('p18'),
          Label("Apellido materno de la madre"),
          fb.textField('p19'),
          Label("Fecha de nacimiento de la madre"),
          fb.dateField(context, 'p20'),
          Label("DNI de la madre"),
          fb.numberField('p21'),
          Label("Nombres de la madre"),
          fb.textField('p22'),
          Label("Apellido paterno de la madre"),
          fb.textField('p23'),
          Label("Apellido materno de la madre"),
          fb.textField('p24'),
          Label("¿Desea ingresar información de un cuidador?"),
          Column(children: fb.radioGroup(["Si", "No"], 'p25', setState)),
          Label("DNI del cuidador/a"),
          fb.numberField('p26'),
          Text("Parentesco con el niño/a", style: boldStyle),
          Column(
              children: fb.radioGroup(
                  ["Tía/o", "Abuela/o", "Prima/o", "Hermana/o", "Otro"],
                  'p27',
                  setState,
                  addWidget: (widgets, value, index) => {
                        if (index == 4 &&
                            (value != null && value.toString() == 'Otro'))
                          {widgets.add(fb.textField('p28'))}
                      })),
          Text("¿Cuenta con un número de celular de contacto?",
              style: boldStyle),
          Column(children: fb.radioGroup(["Si", "No"], 'p29', setState)),
          if (fb.o['p29'] == 'Si') ...[
            Label("Número de celular"),
            fb.numberField('p30'),
            Text("¿A quién pertenece este celular?", style: boldStyle),
            Column(
                children: fb.radioGroup(
                    ["Madre", "Padre", "Cuidador/a"], 'p31', setState)),
            Text("¿Su celular es smartphone?", style: boldStyle),
            Column(children: fb.radioGroup(["Si", "No"], 'p32', setState))
          ]
        ]
      },
      {
        'title': 'Información sobre la vivienda',
        'items': [
          Text("¿Cuenta con red de agua?", style: boldStyle),
          ...fb.checkboxGroup([
            'Red pública dentro de la vivienda',
            'Red pública fuera de la vivienda',
            'Manantial',
            'Río/acequia',
            'Pilón/Grifo público',
            'Camión cisterna',
            'Pozo en la casa/patio',
            'Agua de lluvia',
            'Pozo público',
            'Agua embotellada',
            'Otro (especifique)',
            'No sabe/no responde'
          ], 'p33_',
              addWidget: (widgets, value, index) => {
                    if (index == 10 &&
                        (value != null && value.toString() == 'true'))
                      {
                        widgets.add(TextFormField(
                            minLines: 1,
                            onChanged: fb.setter(setState, 'p33_11_1'),
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: "Enter your text here...",
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline))
                      }
                  }),
          Text("¿¿Cuenta con red de desagüe?", style: boldStyle),
          ...fb.checkboxGroup([
            'Red pública dentro de la vivienda',
            'Letrina pública',
            'Red pública fuera de la vivienda',
            'No hay servicio',
            'Letrina exclusiva',
            'Otro (especifique)'
          ], 'p35_',
              addWidget: (widgets, value, index) => {
                    if (index == 5 &&
                        (value != null && value.toString() == 'true'))
                      {
                        widgets.add(TextFormField(
                            minLines: 1,
                            onChanged: fb.setter(setState, 'p35_6_1'),
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: "Enter your text here...",
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline))
                      }
                  }),
          Text("¿Cuántas habitaciones usan en su hogar sólo para dormir?",
              style: boldStyle),
          fb.numberField('p37'),
          Text("¿Cuántos miembros tiene su hogar?", style: boldStyle),
          fb.numberField('p38'),
          Text("¿Cuántos miembros del hogar tienen menos de 5 años?",
              style: boldStyle),
          Text("Niños:"),
          fb.numberField('p39_1'),
          Text("Niñas:"),
          fb.numberField('p39_2'),
          Text("¿Cuál es su grado de instrucción?", style: boldStyle),
          Column(
              children: fb.radioGroup([
            'Sin educación',
            'Primaria incompleta',
            'Primaria completa',
            'Secundaria incompleta',
            'Secundaria completa',
            'Superior técnico incompleto',
            'Superior técnico completo'
          ], 'p40', setState)),
          Text("¿Cuál es su lengua materna?", style: boldStyle),
          Column(
              children: fb.radioGroup(
                  ["Quechua", "Español", "Otro (especifique)"], 'p41', setState,
                  addWidget: (widgets, value, index) => {
                        if (index == 2 &&
                            (value != null &&
                                value.toString() == 'Otro (especifique)'))
                          {
                            widgets.add(TextFormField(
                                minLines: 1,
                                onChanged: fb.setter(setState, 'p42'),
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: "Enter your text here...",
                                    border: OutlineInputBorder()),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline))
                          }
                      })),
          Text("¿Cuál es su lengua habitual?", style: boldStyle),
          Column(
              children: fb.radioGroup(
                  ["Quechua", "Español", "Otro (especifique)"], 'p43', setState,
                  addWidget: (widgets, value, index) => {
                        if (index == 2 &&
                            (value != null &&
                                value.toString() == 'Otro (especifique)'))
                          {
                            widgets.add(TextFormField(
                                minLines: 1,
                                onChanged: fb.setter(setState, 'p44'),
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: "Enter your text here...",
                                    border: OutlineInputBorder()),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline))
                          }
                      })),
          Text(
              "¿Actualmente, ¿su hogar recibe asistencia de algún programa social?",
              style: boldStyle),
          Column(children: fb.radioGroup(["Si", "No"], 'p45', setState)),
          ...("o['p45']" == 'Si'
              ? [
                  /*Text("¿De cuál de los siguientes programas sociales?",
                      style: boldStyle),
                  ...fb.checkboxGroup([
                    'PRONOEI o QALIWARMA',
                    'Programa "Jóvenes Productivos"',
                    'Comedor popular',
                    'Vaso de leche',
                    'Wawa Wasi/Cuna Mas',
                    'Programa Trabaja Perú',
                    'Programa JUNTOS',
                    'Centro de Emergencia Mujer - CEM',
                    'Programa Beca 18',
                    'Programa "Impulsa Perú"',
                    'Programa de Alfabetización (PNA/DIALFA, antes PRONAMA)',
                    'Programa Bono Gas (FISE)',
                    'Pensión 65'
                  ], 'p46_',
                      onChanged: (value, name) => setO(setState, value, name))*/
                ]
              : []),
          Text("¿Algún miembro del hogar presenta algún tipo de discapacidad?",
              style: boldStyle),
          Column(children: fb.radioGroup(["Si", "No"], 'p47', setState)),
          ...(fb.o['p47'] == 'Si'
              ? [
                  Text("Tipo de discapacidad", style: boldStyle),
                  ...fb.checkboxGroup([
                    'Visual',
                    'Auditiva',
                    'Musculoesquelética (física)',
                    'Intelectual',
                    'Visceral (Asociadas a enfermedades. Por ejemplo: Síndrome de Down, insuficiencia renal, enfermedades del dolor)',
                    'Otro (especifique)'
                  ], 'p48_',
                      addWidget: (widgets, value, index) => {
                            if (index == 5 &&
                                (value != null && value.toString() == 'true'))
                              {
                                widgets.add(TextFormField(
                                    minLines: 1,
                                    onChanged: fb.setter(setState, 'p49'),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText: "Enter your text here...",
                                        border: OutlineInputBorder()),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline))
                              }
                          })
                ]
              : []),
          Text("Parentesco con el niño/a", style: boldStyle),
          Column(
              children: fb.radioGroup([
            'Madre',
            'Padre',
            'Tía/o',
            'Abuela/o',
            'Prima/o',
            'Hermana/o',
            'Otro'
          ], 'p50', setState)),
          ...("o['p47']" == 'Si'
              ? [
                  Text("¿Cuenta con el carnet de CONADIS?", style: boldStyle),
                  ...fb.radioGroup(['Si', 'No'], 'p51', setState)
                ]
              : [])
        ]
      },
      {
        'title': 'Información sobre discapacidad',
        'items': [
          Text("¿El niño/niña presenta algún tipo de discapacidad?",
              style: boldStyle),
          Column(children: fb.radioGroup(["Si", "No"], 'p52', setState)),
          ...(fb.o['p52'] == 'Si'
              ? [
                  Text("Tipo de discapacidad", style: boldStyle),
                  ...fb.checkboxGroup([
                    'Visual',
                    'Auditiva',
                    'Musculoesquelética (física)',
                    'Intelectual',
                    'Visceral (Asociadas a enfermedades. Por ejemplo: Síndrome de Down, insuficiencia renal, enfermedades del dolor)',
                    'Otro (especifique)'
                  ], 'p53_',
                      addWidget: (widgets, value, index) => {
                            if (index == 5 &&
                                (value != null && value.toString() == 'true'))
                              {
                                widgets.add(TextFormField(
                                    minLines: 1,
                                    onChanged: fb.setter(setState, 'p54'),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText: "Enter your text here...",
                                        border: OutlineInputBorder()),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline))
                              }
                          }),
                  Text("¿Cuenta con el carnet de CONADIS?", style: boldStyle),
                  ...fb.radioGroup(['Si', 'No'], 'p55', setState)
                ]
              : [])
        ]
      },
      {
        'title': 'Información sobre los controles del niño o niña',
        'items': [
          Text("En estos momentos, ¿cuenta con la tarjeta CRED de su niño/a?",
              style: boldStyle),
          ...fb.radioGroup([
            'Si',
            'Si, pero en la tarjeta no hay registro de ningún control',
            'No'
          ], 'p56', setState),
          Text("¿Tiene su control CRED al día, según su carnet?",
              style: boldStyle),
          Text("Fecha del último control"),
          fb.textField('p57_1'),
          Text("Fecha del último control"),
          fb.textField('p57_2'),
          Label("¿A qué Establecimiento de Salud asiste?"),
          fb.textField('p58'),
          Label("Otro (especifique)"),
          fb.textField('p59'),
          Label("Peso del último control"),
          fb.numberField('p60'),
          Label("Talla del último control"),
          fb.numberField('p61'),
        ]
      },
      {
        'title': 'Información sobre dosaje de hemoglobina',
        'items': [
          Text("Fecha del último dosaje de hemoglobina", style: boldStyle),
          fb.dateField(context, 'p62'),
          Text("¿En caso se haya realizado en otra institución, ¿dónde?",
              style: boldStyle),
          fb.textField('p63'),
          Text("¿Cuál fue el valor obtenido? (valor ajustado por altura)",
              style: boldStyle),
          fb.numberField('p64'),
          Text("¿Ha recibido sobres de sangrecita en el último mes?",
              style: boldStyle),
          ...fb.radioGroup(['Si', 'No'], 'p65', setState)
        ]
      },
      {
        'title': 'Suplementación',
        'items': [
          Text(
              "¿El niño/a ha recibido algún tipo de suplemento de hierro por el Establecimiento de Salud?",
              style: boldStyle),
          ...fb.radioGroup(['Si', 'No'], 'p66', setState),
          Text(
              "¿El niño/a está consumiendo el suplemento entregado por el Establecimiento de Salud?",
              style: boldStyle),
          ...fb.radioGroup(['Si', 'No'], 'p67', setState),
          Text(
              "¿Está consumiendo otro tipo de suplemento? (comprado, regalado, etc.)",
              style: boldStyle),
          ...fb.radioGroup(['Si', 'No'], 'p68', setState,
              addWidget: (widgets, value, index) => {
                    if (index == 1 &&
                        (value != null && value.toString() == 'Si'))
                      {
                        widgets.add(Text(
                            "¿Qué suplemento? (Puede indicar el nombre comercial)",
                            style: boldStyle)),
                        widgets.add(TextFormField(
                            minLines: 1,
                            onChanged: fb.setter(setState, 'p69'),
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: "Enter your text here...",
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline))
                      }
                  }),
        ]
      },
      {
        'title': 'Signos de alarma',
        'items': [
          Text(
              "En los últimas 15 días su niño/a ha tenido alguno de estos síntomas o dolencias",
              style: boldStyle),
          ...fb.checkboxGroup([
            'Tos',
            'Nariz tapada/moco líquido',
            'Dolor de garganta',
            'Ronquera',
            'Dolor de oído o secreciones del oído',
            'Fiebre',
            'Respiración agitada',
            'Hundimiento de la piel entre costillas',
            'Ninguno',
            'No sabe / no responde'
          ], 'p70_'),
          Label("¿En los últimos 15 días, ¿Su niño/a ha tenido diarrea?"),
          ...fb.radioGroup(['Si', 'No'], 'p71', setState),
          Label("La próxima visita será el:"),
          fb.dateField(context, 'p72'),
        ]
      },
    ];

    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: new Text(widget.id == null
            ? 'Ficha Inicio de Niño'
            : 'Ficha Seguimiento de Niño'),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 5.0,
      ),
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

                        http2
                            .post('/api/minsa/children', fb, state: this)
                            .then((response) {
                          setState(() {
                            var result = json.decode(response.body);
                            if (fb.o['_id'] == null) {
                              if (result['_id'] != null) {
                                context.replace('/children/' +
                                    result['_id']['\$oid'] +
                                    '/edit');
                                widget.mm!.observer!('appBar', false);
                              } else
                                context.replace('/children');
                            }
                            fb.showSnackBar(context, "Datos grabados!");
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
