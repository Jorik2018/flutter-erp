import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription>? cameras;

  CameraController? _cameraController;

  List<AssetEntity>? _galleryPhotos;

  @override
  void initState() {
    initializeCamera();
    getImagesFromGallery();
    super.initState();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    _cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> getImagesFromGallery() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();

    if (!result.isAuth) return;

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isEmpty) return;

    final List<AssetEntity> photos = await albums.first.getAssetListPaged(
      page: 0,
      size: 100,
    );

    if (!mounted) return;

    setState(() {
      _galleryPhotos = photos;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(height: 0.0, width: 0.0);
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: CameraPreview(_cameraController!),
          ),
          _cameraButtonWidget(),
          _galleryWidget(),
        ],
      ),
    );
  }

  Widget _cameraButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.flash_on, color: Colors.white, size: 30),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            Icon(Icons.camera_alt, size: 30, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _galleryWidget() {
    return Positioned(
      bottom: 100,
      right: 0,
      left: 0,
      child: Container(
        height: 55,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _galleryPhotos!.length,
          itemBuilder: (_, index) {
            final asset = _galleryPhotos![index];
            /**Error: The name 'Uint8List' isn't a type, so it can't be used as a type argument.
Try correcting the name to an existing type, or defining a type named 'Uint8List' */
            return FutureBuilder<Uint8List?>(
              future: asset.thumbnailData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 8),
                    //color: Colors.grey.withOpacity(0.2),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 55,
                  width: 50,
                  //decoration: BoxDecoration(color: Colors.red.withOpacity(.2)),
                  child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
