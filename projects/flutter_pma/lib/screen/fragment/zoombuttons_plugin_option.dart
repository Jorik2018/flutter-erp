import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class FlutterMapZoomButtons extends StatelessWidget {
  final double minZoom;
  final double maxZoom;
  final bool mini;
  final double padding;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomInColorIcon;
  final Color? zoomOutColor;
  final Color? zoomOutColorIcon;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;

  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(12));

  const FlutterMapZoomButtons({
    super.key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.mini = true,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInColorIcon,
    this.zoomInIcon = Icons.zoom_in,
    this.zoomOutColor,
    this.zoomOutColorIcon,
    this.zoomOutIcon = Icons.zoom_out,
  });

  @override
  Widget build(BuildContext context) {
    final map = FlutterMapState.maybeOf(context)!;
    return Padding(padding:EdgeInsets.all(15.0),child:Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              
              decoration: BoxDecoration(color: Color.fromARGB(255, 237, 238, 238) ,border: Border.all(color: Colors.grey)),
              child: Padding(padding:EdgeInsets.all(8.0),child:InkWell(
                child: Icon(Icons.add),
                onTap: () {
                  final bounds = map.bounds;
                  final centerZoom = map.getBoundsCenterZoom(bounds, options);
                  var zoom = centerZoom.zoom + 1;
                  if (zoom > maxZoom) {
                    zoom = maxZoom;
                  }
                  map.move(centerZoom.center, zoom,
                      source: MapEventSource.custom);
                },
              ))),
          Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 237, 238, 238) ,border: Border.all(color: Colors.grey)),
              child: InkWell(
                child: Padding(padding:EdgeInsets.all(8.0),child:Icon(Icons.remove)),
                onTap: () {
                  final bounds = map.bounds;
                  final centerZoom = map.getBoundsCenterZoom(bounds, options);
                  var zoom = centerZoom.zoom - 1;
                  if (zoom < minZoom) {
                    zoom = minZoom;
                  }
                  map.move(centerZoom.center, zoom,
                      source: MapEventSource.custom);
                },
              )),
        ],
      ),
    ));
  }
}
