import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  Color themeColor = Color.fromARGB(255, 0, 0, 0);

  late TextEditingController controllerNickname;

  late TextEditingController controllerAboutMe;

  late SharedPreferences prefs;

  String id = '';

  String nickname = '';

  String aboutMe = '';

  String photoUrl = '';

  bool isLoading = false;

  File? avatarImageFile;

  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';
    aboutMe = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';

    controllerNickname = TextEditingController(text: nickname);
    controllerAboutMe = TextEditingController(text: aboutMe);

    // Force refresh input
    setState(() {});
  }

  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      avatarImageFile = File(image.path);
      isLoading = true;
    });

    await uploadFile();
  }

  Future<void> uploadFile() async {
    try {
      final String fileName = id;

      final Reference reference = FirebaseStorage.instance.ref().child(
        fileName,
      );

      final UploadTask uploadTask = reference.putFile(avatarImageFile!);

      // Esperar a que termine la subida
      final TaskSnapshot snapshot = await uploadTask;

      // Obtener la URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      photoUrl = downloadUrl;

      await FirebaseFirestore.instance.collection('users').doc(id).update({
        'nickname': nickname,
        'aboutMe': aboutMe,
        'photoUrl': photoUrl,
      });

      await prefs.setString('photoUrl', photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Upload success");
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: e.message ?? e.toString());
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
          'nickname': nickname,
          'aboutMe': aboutMe,
          'photoUrl': photoUrl,
        })
        .then((data) async {
          await prefs.setString('nickname', nickname);
          await prefs.setString('aboutMe', aboutMe);
          await prefs.setString('photoUrl', photoUrl);

          setState(() {
            isLoading = false;
          });

          Fluttertoast.showToast(msg: "Update success");
        })
        .catchError((err) {
          setState(() {
            isLoading = false;
          });

          Fluttertoast.showToast(msg: err.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                themeColor,
                                              ),
                                        ),
                                        width: 90.0,
                                        height: 90.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: photoUrl,
                                      width: 90.0,
                                      height: 90.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(45.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                : Icon(Icons.account_circle, size: 90.0))
                          : Material(
                              child: Image.file(
                                avatarImageFile!,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(45.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Nickname',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(primaryColor: Color.fromARGB(255, 0, 0, 0)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Sweetie',
                          contentPadding: EdgeInsets.all(5.0),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(primaryColor: Color.fromARGB(255, 0, 0, 0)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Fun, like travel and play PES...',
                          contentPadding: EdgeInsets.all(5.0),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: TextButton(
                  onPressed: handleUpdateData,
                  child: Text('UPDATE', style: TextStyle(fontSize: 16.0)),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
