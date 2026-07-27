import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_erp/apps/flutter_pma/screen/fragment/zoombuttons_plugin_option.dart';

import '../../utils/util.dart';

class MapFragment extends StatefulWidget {
  Map? options;

  LX? mm;

  MapFragment({this.options, this.mm});

  @override
  _MapFragmentState createState() => _MapFragmentState();
}

List layers = [
  {'label': 'Niños', 'layer': 'gra:children', 'visible': true},
  {'label': 'Gestantes', 'layer': 'gra:pregnant_woman', 'visible': true},
  {'label': 'Distritos', 'layer': 'dremh:DISTRITO', 'visible': true},
];

class _MapFragmentState extends State<MapFragment> {
  @override
  void initState() {
    if (widget.mm != null) {
      widget.mm!.observer!('title', 'Mapa PMA');
      widget.mm!.observer!('appBar', false);
    }
  }

  @override
  void dispose() {
    widget.mm!.observer!('appBar', null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var op = widget.options ?? {};
    double lat = op!['lat'] ?? -9.4871398;
    double lon = op!['lon'] ?? -77.5275351;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa PMA'),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 5.0,
        actions: [
          //Padding(padding:EdgeInsets.all(15.0),child: GestureDetector(child:Icon(Icons.layers))),
          //Padding(padding:EdgeInsets.all(15.0),child:GestureDetector(child:Icon(Icons.zoom_in))),
          PopupMenuButton(
            itemBuilder: (bc) {
              return [
                ...layers.map((e) {
                  return PopupMenuItem(
                    child: StatefulBuilder(
                      builder: (c, s) => CheckboxListTile(
                        title: Text(e['label']),
                        value: e['visible'],
                        onChanged: ((value) {
                          s(() {
                            e['visible'] = value;
                          });
                          setState(() {
                            e['visible'] = value;
                          });
                        }),
                      ),
                    ),
                  );
                }).toList(),
                //PopupMenuItem(child: Text("data"),value: 1,)
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              /*options: MapOptions(
                onMapEvent: (e) {
                  if (e is MapEventTap) {
                    MapEventTap met = e;
                    print(met.source);
                    print(met.tapPosition);
                    Alert(this.context, met.tapPosition.toString());
                  }
                },
                center: LatLng(lat, lon),
                zoom: 9.2,
              ),*/
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                ...layers.where((element) => element['visible']).map((e) {
                  return TileLayer(
                    wmsOptions: WMSTileLayerOptions(
                      transparent: true,
                      baseUrl:
                          'http://web.regionancash.gob.pe/geoserver/' +
                          e['layer'].toString().split(':')[0] +
                          '/wms?',
                      layers: [e['layer']],
                    ),
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  );
                }).toList(),
                MarkerLayer(
                  markers: [
                    /*Marker(
                      point: LatLng(lat, lon),
                      width: 40,
                      height: 40,
                      builder: (context) => Icon(
                        Icons.pregnant_woman_rounded,
                        size: 30.0,
                        color: Colors.brown[900],
                      ),
                    ),*/
                  ],
                ),
              ],
              /*nonRotatedChildren: [
                FlutterMapZoomButtons(
                  minZoom: 4,
                  maxZoom: 19,
                  mini: true,
                  padding: 10,
                  alignment: Alignment.topRight,
                ),
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: null,
                ),
              ],*/
            ),
          ),
        ],
      ),
    );
  }
}
