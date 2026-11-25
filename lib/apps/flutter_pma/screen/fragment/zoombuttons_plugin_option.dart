import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

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
    final mapController = MapController.of(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Align(
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: zoomInColor ?? const Color.fromARGB(255, 237, 238, 238),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(zoomInIcon, color: zoomInColorIcon),
                  onTap: () {
                    final camera = mapController.camera;

                    final zoom = (camera.zoom + 1).clamp(minZoom, maxZoom);

                    mapController.move(camera.center, zoom);
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: zoomOutColor ?? const Color.fromARGB(255, 237, 238, 238),
                border: Border.all(color: Colors.grey),
              ),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(zoomOutIcon, color: zoomOutColorIcon),
                ),
                onTap: () {
                  final camera = mapController.camera;

                  final zoom = (camera.zoom - 1).clamp(minZoom, maxZoom);

                  mapController.move(camera.center, zoom);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
