import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter_pma/utils/util.dart';

class ProfileFragment extends StatefulWidget {
  Function? navigateTo;

  LX? mm;

  int? id;

  ProfileFragment({super.key, this.navigateTo, this.id, this.mm});

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();

  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  FormBuilder fb = FormBuilder({'status': 1});

  ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(16.0),
      primary: Colors.white,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(fontSize: 20));

  List roles2 = [];

  _reload(int uid) {
    var data = {
      'query': '''
          query{
            user(uid:${uid} roleName:"pma_") {
              uid,
              name
              mail,
              fullName,
              directoryId,
              names,
              firstSurname,
              lastSurname,
              status,
              userRoles {
                pk {
                  rid
                },
                role{
                  name
                },
                active
              }
            }
          }
          '''
    };
    http2.gql('/api/admin/graphql', data, state: this).then((result) {
      fb.o = result['user'];
      List userRoles = fb.o.remove('userRoles');
      List roles = [];
      fb.o['userRoles2'] = userRoles.fold({}, (t, e) {
        roles.add({'value': e['pk']['rid'], 'label': e['role']['name']});
        (t as Map)[e['pk']['rid']] = e['active'] ?? false;
        return t;
      });
      setState(() {
        roles2 = roles;
        fb.vars['pass'] = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fb.vars['pass'] = true;
    fb.expanded[0] = true;
    fb.setState = setState;
    Future.delayed(Duration.zero, () {
      _reload(widget.id != null ? int.parse(widget.id.toString()) : 0);
    });
    widget.mm!.observer!('appBar', false);
  }

  @override
  void dispose() {
    widget.mm!.observer!('appBar', null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fb.setState = setState;
    String? code = fb.o['code'];
    String? pass = fb.o['pass'];
    List panels = [
      {
        'title': 'Información General',
        'items': [
          Label("Nombre de usuario:"),
          fb.textField('name'),
          Label("Correo electronico:"),
          fb.textField('mail'),
          Label("DNI:"),
          fb.numberField(
            'code',
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                suffixIcon: code != null && code.length >= 8
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.refresh),
                      )
                    : null),
          ),
          ...[
            Label("Nombre:"),
            fb.textField('names'),
            Label("Apellido paterno:"),
            fb.textField('firstSurname'),
            Label("Apellido materno:"),
            fb.textField('lastSurname'),
            Label("Direccion:"),
            fb.textField('address',
                keyboardType: TextInputType.multiline, required: false),
            Label("Número de celular:"),
            fb.numberField('phone',
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: "Ingrese numero celular",
                )),
          ],
          Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(children: [
                Spacer(),
                ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Guardar cambios'),
                    icon: Icon(Icons.save))
              ]))
        ]
      },
      {
        'title': 'Cambiar Contraseña',
        'items': [
          Label("Contraseña Actual:"),
          fb.textField('pass', obscureText: true),
          Label("Nueva Contraseña:"),
          fb.textField('newPass', obscureText: true),
          Label("Confirmar Contraseña:"),
          fb.textField(
            'confirmPass',
            obscureText: true,
          ),
          Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(children: [
                Spacer(),
                ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Cambiar contraseña'),
                    icon: Icon(Icons.save))
              ]))
        ]
      }
    ];

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Mi cuenta'),
          elevation:
              defaultTargetPlatform == TargetPlatform.android ? 5.0 : 5.0,
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
              ))
            ])));
  }
}
