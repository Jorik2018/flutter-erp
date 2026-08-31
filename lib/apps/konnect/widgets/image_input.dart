import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_erp/apps/konnect/screens/register/edit_view_photo_page.dart';
import 'package:flutter_erp/apps/konnect/utils/colors.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

enum InputType { card, profile }

enum PhotoInputType { camera, gallery }

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final InputType input;

  ImageInput(this.onSelectImage, this.input);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.input == InputType.card
            ? GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kColorPrimary),
                  ),
                  child: _storedImage != null
                      ? Image.file(
                          _storedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Icon(Icons.add, size: 150, color: Colors.grey[400]),
                  alignment: Alignment.center,
                ),
                onTap: _readImage,
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: kColorPrimary,
                    radius: 52.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      radius: 50.0,
                      child: ClipOval(
                        child: _storedImage != null
                            ? Image.file(
                                _storedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/avatar.png',
                                  color: Colors.grey.shade500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _readImage,
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundColor: kColorPrimaryDark,
                        child: Icon(Icons.edit, color: kColorPrimary),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Future<PhotoInputType?> _chooseInputDialogBox() {
    return showDialog<PhotoInputType>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Image',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton.icon(
                label: Text(
                  'Open Camera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  Navigator.pop(context, PhotoInputType.camera);
                },
              ),
              const SizedBox(height: 15),
              TextButton.icon(
                label: const Text('Choose from Gallery'),
                icon: const Icon(Icons.photo),
                onPressed: () {
                  Navigator.pop(context, PhotoInputType.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _imageManipulation(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: source,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return null;
    }

    File imageFile = File(pickedImage.path);

    debugPrint('image size after picking: ${imageFile.lengthSync()}');

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: kColorPrimaryDark,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: const [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: const [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      imageFile = File(croppedFile.path);
    }

    debugPrint('image size after cropping: ${imageFile.lengthSync()}');

    return imageFile;
  }

  Future<void> _readImage() async {
    File? imageFile;

    if (_storedImage == null) {
      final PhotoInputType? input = await _chooseInputDialogBox();

      if (input == null) {
        return;
      }

      imageFile = input == PhotoInputType.camera
          ? await _imageManipulation(ImageSource.camera)
          : await _imageManipulation(ImageSource.gallery);

      if (imageFile == null) {
        return;
      }
    } else {
      imageFile = _storedImage;

      final File? returned = await Navigator.push<File>(
        context,
        MaterialPageRoute<File>(
          fullscreenDialog: true,
          builder: (context) => EditViewPhotoPage(
            chooseInputDialog: _chooseInputDialogBox,
            toEditImage: _imageManipulation,
            storedImage: _storedImage!,
          ),
        ),
      );

      if (returned != null) {
        imageFile = returned;
      }
    }

    if (imageFile == null || !mounted) {
      return;
    }

    setState(() {
      _storedImage = imageFile;
    });

    debugPrint(imageFile.absolute.path);

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);

    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    widget.onSelectImage(savedImage);
  }
}
