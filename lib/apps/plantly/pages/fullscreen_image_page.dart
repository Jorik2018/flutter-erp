import 'package:flutter/material.dart';
import 'zoomable_image_page.dart';

class FullscreenImagePage extends StatelessWidget {
  final String imgPath;
  FullscreenImagePage(this.imgPath);

  final LinearGradient backgroundGradient = new LinearGradient(
    colors: [
      new Color(0x10000000), // Light black
      new Color(0x30000000), // Dark black
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.center,
                child: Hero(tag: imgPath, child: Image.asset(imgPath)),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: Column(
                  // I need to add a column to set the MainAxisSize to min,
                  // otherwise the appbar takes all the screen height and the image is no more clickable
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: Colors.black),
                      ),
                      actions: <Widget>[
                        new IconButton(
                          onPressed: () => Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (_) => new ZoomableImagePage(imgPath),
                            ),
                          ),
                          icon: Icon(Icons.zoom_in, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
