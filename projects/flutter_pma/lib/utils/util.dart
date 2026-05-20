import 'dart:collection';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pma/utils/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LX {
  void Function(dynamic, dynamic)? observer;
}

class Util {
  Util._();

  static const String name = "Registration and Login";
  static const String store = "Online Store\n For Everyone";
  static const String skip = "SKIP";
  static const String next = "NEXT";
  static const String gotIt = "GOT IT";
  static String API_URL = dotenv.env['API_URL']!;

  static String userName = "";
  static String emailId = "";
  static List<String> descriptionList = <String>[];
  static List<String> mediaList = <String>[];
  static List<ListItem> listItems = <ListItem>[];
}

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

Alert(BuildContext context, String msg,
    {String title = "Message", List buttons = const ['OK']}) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: buttons
        .map((e) => TextButton(
              child: Text(e.toString()),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ))
        .toList(),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLoaderDialog(BuildContext context, {String? msg}) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(msg ?? "Enviando...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class HTTP {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  Future<http.Response?> get(String url, {var headers, State? state}) async {
    Map<String, String> h = Map.from(this.headers);
    if (headers is Function) {
      h = (headers)(h);
    } else if (headers != null) {
      h = HashMap.from(
          headers.map((key, value) => MapEntry(key.toString(), value)));
    }
    if (state != null) showLoaderDialog(state.context, msg: 'Cargando...');
    http.Response? response;
    try {
      response = await http.get(Uri.parse(url.startsWith("http")?url:(Util.API_URL + url)), headers: h);
      if (state != null) Navigator.of(state.context, rootNavigator: true).pop();
    } catch (e) {
      if (state != null) Navigator.of(state.context, rootNavigator: true).pop();
      if (state != null) Alert(state.context, '', title: e.toString());
    } finally {
      if (response != null &&
          (response.statusCode == 500 ||
              response.statusCode == 401 ||
              response.statusCode == 500)) {
        if (state != null) Alert(state.context, '', title: 'Error');
      }
    }

    return response;
  }

  Future post(String url, Object body,
      {String? config,
      void Function(bool)? onLoading,
      State? state,
      void Function(String, http.Response?)? onError,
      var headers}) async {
    if (body is FormBuilder) {
      body = json.encode((body as FormBuilder).toMap());
    } else if (!(body is String)) {
      body = json.encode(body);
    }
    if (state != null) showLoaderDialog(state.context);
    if (onLoading != null) onLoading(true);

    Map<String, String> h = new Map.from(this.headers);
    if (headers is Function) {
      h = (headers)(h);
    } else if (headers != null) {
      h = new Map.from(headers);
    }

    http.Response response = await http.post(Uri.parse(Util.API_URL + url),
        body: body.toString(), headers: h);
    if (onLoading != null)
      onLoading(false);
    else if (state != null)
      Navigator.of(state.context, rootNavigator: true).pop();
    if (response.statusCode == 500 ||
        response.statusCode == 401 ||
        response.statusCode == 500) {
      if (onError != null)
        onError('', response);
      else if (state != null) Alert(state.context, '', title: 'Error');
    }
    return response;
  }

  Future gql(String url, Object body,
      {String? config,
      State? state,
      var headers,
      void Function(bool)? onLoading,
      void Function(String, http.Response?)? onError}) async {
    if (body is FormBuilder) {
      body = json.encode((body as FormBuilder).toMap());
    } else if (!(body is String)) {
      body = json.encode(body);
    }
    if (state != null) showLoaderDialog(state.context, msg: 'Cargando...');
    if (onLoading != null) onLoading(true);
    Map<String, String> h = new Map.from(this.headers);
    if (headers is Function) {
      h = (headers)(h);
    } else if (headers != null) {
      h = headers;
    }
    http.Response? response;
    try {
      response = await http.post(Uri.parse(Util.API_URL + url),
          body: body.toString(), headers: h);
              if (onLoading != null)
      onLoading(false);
    else if (state != null)
      Navigator.of(state.context, rootNavigator: true).pop();
    if (response.statusCode == 401 || response.statusCode == 500) {
      if (onError != null)
        onError('', response);
      else if (state != null) Alert(state.context, '', title: 'Error');
    }
    var v = jsonDecode(response.body);
    if (v['errors'] != null) {
      if (onError != null)
        onError(v['errors'].toString(), response);
      else if (state != null)
        Alert(state.context, v['errors'].toString(), title: 'Error');
    }
    return v['data'];
    } catch (e) {
      if (state != null) Navigator.of(state.context, rootNavigator: true).pop();
      if (state != null) Alert(state.context, '', title: e.toString());
    }
return null;
  }
}

TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

Widget Label(String text) {
  return Text(text, style: boldStyle);
}

HTTP http2 = HTTP();

class XMap {
  HashMap map = HashMap();

  Map<String, dynamic> toJson() {
    return HashMap.from(
        map.map((key, value) => MapEntry(key.toString(), value)));
  }

  Map asMap() {
    return map;
  }

  operator [](var i) => map[i];

  operator []=(var i, var value) => map[i] = value;
}

class FormBuilder {
  Map _o = {};

  Map vars = {};

  Map expanded = {};

  Map controllerMap = {};

  void Function(void Function())? _setState;

  FormBuilder([Map? o]) {
    if (o != null) _o = o;
  }

  set o(Map o0) {
    _o = o0;
    expanded = {};
    vars = {};
    controllerMap = {};
  }

  set setState(void Function(void Function()) setState) {
    _setState = setState;
  }

  Map get o {
    return _o;
  }

  Widget dropdownButton(
      List _options, String key, void Function(void Function()) setState,
      {List Function(Object)? adapter, void Function(Object?)? onChanged}) {
    var value = _o[key] ?? '';
    var v = '';
    _options.forEach((element) {
      if (adapter != null) {
        List l = element is String ? ['', element] : adapter(element);
        element = l[0];
      }
      if (value == element) {
        v = element;
      }
    });
    return DropdownButton(
      value: v,
      items: _options.map((_o) {
        if (adapter != null) {
          List l = _o is String ? ['', _o] : adapter(_o);
          return new DropdownMenuItem(value: l[0], child: new Text(l[1]));
        } else
          return new DropdownMenuItem(value: _o, child: new Text(_o));
      }).toList(),
      onChanged: (e) {
        setState(() {
          _o[key] = e;
          if (onChanged != null) onChanged(e);
        });
      }, //setter,
      isExpanded: true,
    );
  }

  List<Widget> radioGroup(
      List options, String key, void Function(void Function()) setState,
      {void Function(List<Widget>, Object?, int)? addWidget}) {
    return (options.asMap().entries).expand((entry) {
      int index = entry.key;
      var item = entry.value;
      var text = item;
      if (item != null && item is! String) {
        text = item['label'];
        item = item['value'];
      }
      List<Widget> widgets = [];
      widgets.add(ListTile(
        title: Text(text),
        leading: Radio(
            groupValue: _o[key] ?? '',
            value: item,
            onChanged: (e) {
              setState(() {
                _o[key] = e ?? '';
              });
            },
            splashRadius: 35,
            toggleable: true,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ));
      if (addWidget != null) {
        //addWidget(widgets, _o![key], index);
      }
      return widgets.toList();
    }).toList();
  }

  Widget numberField(String name,
      {Function? setState,
      InputDecoration? decoration,
      int? min,
      String? Function(String?)? validator,
      bool required = true,
      int? max,
      TextAlign textAlign = TextAlign.right}) {
    if (_setState != null && setState == null) setState = _setState;
    TextEditingController? controller = controllerMap[name];
    if (controller == null) {
      controllerMap[name] = (controller = TextEditingController());
    }
    if (decoration == null)
      decoration = InputDecoration(
          prefixIcon: Icon(Icons.onetwothree),
          hintText: "Enter your number here...");
    if (_o[name] != null) {
      var cursorPos = controller.selection.base.offset;
      controller.text = _o[name];
      controller.value = controller.value.copyWith(
          text: controller.text,
          selection: TextSelection(
              baseOffset: cursorPos > -1 ? cursorPos : controller.text.length,
              extentOffset:
                  cursorPos > -1 ? cursorPos : controller.text.length));
    }

    return TextFormField(
      controller: controller,
      textAlign: textAlign,
      onChanged: (value) {
        setState!(() {
          _o[name] = value;
        });
      },
      decoration: decoration,
      validator: validator ??
          (String? value) {
            return required && (_o[name] == null || _o[name].length == 0)
                ? "Campo requerido."
                : null;
          },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget textField(String name,
      {TextAlign textAlign = TextAlign.left,
      InputDecoration? decoration,
      bool obscureText = false,
      TextInputType? keyboardType,
      String? placeholder="Enter your text here....",
      bool required = true,
      Function? setState,
      int? maxLines = 1,
      String? Function(String?)? validator,
      bool readOnly = false,
      Function()? onTap,  String Function(dynamic v)? adapter}) {
    if (_setState != null && setState == null) setState = _setState;
    TextEditingController? controller = controllerMap[name];
    if (controller == null) {
      controllerMap[name] = (controller = TextEditingController());
    }
    if (_o[name] != null) {
      var cursorPos = controller.selection.base.offset;
      controller.text = adapter!=null?adapter(_o[name]):_o[name];
      controller.value = controller.value.copyWith(
          text: controller.text,
          selection: TextSelection(
              baseOffset: cursorPos > -1 ? cursorPos : controller.text.length,
              extentOffset:
                  cursorPos > -1 ? cursorPos : controller.text.length));
    }
    if (keyboardType == TextInputType.multiline) maxLines = null;
    return TextFormField(
        textAlign: textAlign,
        controller: controller,
        obscureText: obscureText,
        onChanged: (value) {
          setState!(() {
            _o[name] = value;
          });
        },
        decoration: decoration != null
            ? decoration
            : InputDecoration(
                prefixIcon: Icon(Icons.abc_rounded),
                hintText: placeholder),
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onTap: onTap,
        validator: validator ??
            (String? value) {
              return required && (_o[name] == null || _o[name].length == 0)
                  ? "Campo requerido."
                  : null;
            });
  }

  TextStyle bold20Style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  List<ExpansionPanel> expansionPanel(List panels) {
    int index = -1;
    return (panels.map<ExpansionPanel>((e) {
      index++;
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(e['title'], style: bold20Style),
          );
        },
        isExpanded: expanded[index] != null && expanded[index],
        body: Padding(
            padding: EdgeInsets.all(15.0),
            child: e['items'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: e['items'].cast<Widget>())
                : Text('Empty!')),
      );
    })).toList();
  }

  void setO(Function setState, Object? value, String? name) {
    setState(() {
      _o[name] = value;
    });
  }

  void Function(String)? setter(Function setState, name) {
    return (Object? value) {
      setState(() {
        _o[name] = value;
      });
    };
  }

  HashMap<String, Object> toMap([Map? old]) {
    HashMap<String, Object> m = HashMap();
    (old != null ? old : _o).entries.forEach((element) {
      if (element.value != null) m[element.key.toString()] = element.value;
    });
    return m;
  }

  List<Widget> checkboxGroup(List options, String valueName,
      {void Function(void Function())? setState,
      int mode = 0,
      void Function(List<Widget>, Object?, int)? addWidget}) {
    return (options.asMap().entries).expand((entry) {
      if (_setState != null && setState == null) setState = _setState;
      int index = entry.key;
      var item = entry.value;
      var text = item;
      if (item != null && item is! String) {
        text = item['label'];
        item = item['value'];
      }

      List<Widget> widgets = [];
      Object? value;
      bool selected = false;
      String valueName2 = "";
      if (mode == 2) {
        var tm = _o[valueName];
        if (tm is Map) {
          XMap nm = XMap();
          tm.entries.forEach((element) {
            nm[element.key] = element.value;
          });
          tm = nm;
        }
        XMap? v = tm;
        if (v == null) {
          v = XMap();
        }
        value = v[item];
        v[item] = selected = value != null && value.toString() == 'true';
      } else {
        valueName2 = valueName + (index + 1).toString();
        value = _o[valueName2];
        selected = value != null && value.toString() == 'true';
      }
      widgets.add(CheckboxListTile(
          title: Text(text),
          controlAffinity: ListTileControlAffinity.leading,
          value: selected,
          onChanged: (Object? value) {
            setState!(() {
              if (mode == 2) {
                var tm = _o[valueName];
                if (tm is Map) {
                  XMap nm = XMap();
                  tm.entries.forEach((element) {
                    nm[element.key] = element.value;
                  });
                  tm = nm;
                }
                XMap? v = tm;
                if (v == null) {
                  v = XMap();
                }
                v[item] = value;
                _o[valueName] = v;
              } else
                _o[valueName2] = value;
            });
          }));
      if (addWidget != null) {
        addWidget(widgets, value, index);
      }
      return widgets.toList();
    }).toList();
  }

  Widget dateField(
    BuildContext context,
    String key, {
    void Function(void Function())? setState,
    TextAlign textAlign = TextAlign.center,
    String? type,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    if (_setState != null && setState == null) setState = _setState;
    TextEditingController dateinput = TextEditingController();
    Object? value = _o![key];
    return TextFormField(
      controller: dateinput..text = value != null ? value.toString() : '',
      textAlign: textAlign,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.clear),
          ),
          hintText: "Enter Date"),
      readOnly: true,
      onTap: () async {
        DateTime? old;
        try {
          old = DateFormat('yyyy-MM-dd').parse(_o![key]);
        } catch (e) {
          print(e);
        }
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: old != null ? old : DateTime.now(),
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));
        if (pickedDate == null) pickedDate = old;
        Object value = pickedDate != null
            ? DateFormat('yyyy-MM-dd').format(pickedDate)
            : '';

        setState!(() {
          _o![key] = value;
        });
      },
    );
  }

  void showSnackBar(BuildContext context, String s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
