import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/dialogitem.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class StartRequestScreen extends StatefulWidget {
  static const String routeName = '/material/persistent-bottom-sheet';

  @override
  StartRequestState createState() => StartRequestState();
}

class StartRequestState extends State<StartRequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VoidCallback? _showBottomSheetCallback;

  LocationData ? _startLocation;

  LocationData ? _currentLocation;

  StreamSubscription<LocationData>? _locationSubscription;

  final Location _location = Location();

  String? error;

  bool currentWidget = true;

  Image? image1;

  @override
  void initState() {
    super.initState();

    initPlatformState();
/**error:A value of type 'StreamSubscription<LocationData>' can't be assigned to a variable of type 'StreamSubscription<Map<String, double>>?'.
Try changing the type of the variable, or casting the right-hand type to 'StreamSubscription<Map<String, double>>?' */
    _locationSubscription = _location.onLocationChanged.listen((
      result,
    ) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    LocationData? location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
/**error:A value of type 'Null' can't be assigned to a variable of type 'LocationData'.
Try changing the type of the variable, or casting the right-hand type to 'LocationData'. */
      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;

    if (_currentLocation == null) {
      widgets = [];
    } else {
      widgets = [
        Expanded(
          child: Column(
            children: <Widget>[
              Image.network(
                "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation?.latitude},${_currentLocation?.longitude}&zoom=18&size=640x400&key=AIzaSyDT8-ttxGcKLv7LyC62JcSgT2TBYnXvfFw",
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ];
    }

    // widgets.add(Center(
    //     child: Text(_startLocation != null
    //         ? 'Start location: $_startLocation\n'
    //         : 'Error: $error\n')));

    // widgets.add(Center(
    //     child: Text(_currentLocation != null
    //         ? 'Continuous location: $_currentLocation\n'
    //         : 'Error: $error\n')));
    widgets.add(DriverSheet());
    return Scaffold(
      appBar: AppBar(title: Text("Example 1 Page")),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
      ),
    );
  }

  void _showMessage() {
    final ThemeData theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Set backup account'),
          children: <Widget>[
            DialogItem(
              icon: Icons.account_circle,
              color: theme.primaryColor,
              text: 'Economy',
              onPressed: () {
                Navigator.pop(context, 'username@gmail.com');
              },
            ),
            DialogItem(
              icon: Icons.account_circle,
              color: theme.primaryColor,
              text: 'Large',
              onPressed: () {
                Navigator.pop(context, 'user02@gmail.com');
              },
            ),
            DialogItem(
              icon: Icons.add_circle,
              text: 'Premium',
              color: theme.disabledColor,
            ),
          ],
        );
      },
    );
  }
}

String _defaultClass = 'Economy';
List<String> className = ['Economy', 'Large', 'Premium'];

class DriverSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.traffic),
              //buildDropdownButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButton() {
    String dropdown1Value = 'Free';
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: const Text('Simple dropdown:'),
            trailing: DropdownButton<String>(
              value: dropdown1Value,
              onChanged: (String? newValue) {
                //setState(() { dropdown1Value = newValue; });
              },
              items: <String>['One', 'Two', 'Free', 'Four'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
