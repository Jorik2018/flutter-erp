import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImagePage extends StatelessWidget {
  final String imgPath;

  const ZoomableImagePage(this.imgPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // mejor para imágenes
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: imgPath,
              child: PhotoView(
                imageProvider: AssetImage(imgPath),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
              ),
            ),
          ),

          /// Botón cerrar (más simple que AppBar hack)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}