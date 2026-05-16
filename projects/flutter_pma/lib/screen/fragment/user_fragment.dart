import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter_pma/utils/util.dart';

class UserFragment extends StatefulWidget {

  Function? navigateTo;

  LX? mm;

  int? id;

  UserFragment({super.key, this.navigateTo, this.id,this.mm});

  @override
  _UserFragmentState createState() => _UserFragmentState();

}

class _UserFragmentState extends State<UserFragment> {
  
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();

  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  FormBuilder fb = FormBuilder({'status': 1});

  ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(16.0),
      primary: Colors.white,
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(fontSize: 20));

  List roles2=[];

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
      List roles=[];
      fb.o['userRoles2'] = userRoles.fold({}, (t, e) {
        roles.add({'value': e['pk']['rid'], 'label': e['role']['name']});
        (t as Map)[e['pk']['rid']] = e['active']??false;
        return t;
      });
      setState(() {
        roles2=roles;
        fb.vars['pass'] = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fb.vars['pass'] = true;
    fb.setState = setState;
    Future.delayed(Duration.zero, () {
      _reload(widget.id != null?int.parse(widget.id.toString()):0);
    });
    widget.mm!.observer!('appBar', false);
  }

  @override
  void dispose() {
    
    widget.mm!.observer!('appBar',null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fb.setState = setState;
    String? code = fb.o['code'];
    String? pass = fb.o['pass'];
    List<Widget> panels = [
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
      Label("Contraseña:"),
      fb.textField(
        'pass',
        obscureText: fb.vars['pass'],
        decoration: InputDecoration(
            suffixIcon: pass != null && pass.length >= 0
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        fb.vars['pass'] = !fb.vars['pass'];
                      });
                    },
                    icon: Icon(
                      fb.vars['pass'] ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                : null),
      ),
      Label("Estado:"),
      Column(
          children: fb.radioGroup([
        {'value': 0, 'label': 'Bloqueado'},
        {'value': 1, 'label': 'Activo'}
      ], 'status', setState)),
      Label("Roles:"),
      ...fb.checkboxGroup(roles2, 'userRoles2', mode: 2)
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.id==null? 'Nuevo Usuario' : 'Editar Usuario'),
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
                        children: panels)),
              )),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              /*if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Faltan completar campos!'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ));
                          return;
                        }*/
                              _formKey.currentState!.save();
                              var o = fb.o;
                              var userRoles = o['userRoles2'];
                              o['userRoles'] = (userRoles.asMap().entries)
                                  .map((entry) => {
                                        'pk': {'rid': entry.key},
                                        'active': entry.value
                                      })
                                  .toList();
                              http2.post(
                                '/api/admin/user',
                                fb,
                                state: this
                              ).then((response) {
                                var result = json.decode(response.body);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text('Datos grabados!'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ));
                                if (fb.o['uid'] == null) {
                                  if (result['uid'] != null) {
                                    context
                                        .replace('/user/${result['uid']}/edit');
                                        widget.mm!.observer!('appBar', false);
                                  } else {
                                    context.replace('/user');
                                  }
                                }
                              });
                            },
                            label: const Text('Grabar'),
                            icon: Icon(Icons.save))
                      ]))
            ])));
  }
}
