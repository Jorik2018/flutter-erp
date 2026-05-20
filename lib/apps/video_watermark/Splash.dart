import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_erp/apps/video_watermark/views/HomePage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
  
}

class _SplashState extends State<Splash> {

  Future<bool> checkPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final newStatus = await Permission.location.request();
      return newStatus.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    //   final newstatus = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      return true;
    } else {
      return false;
    }
  }

@override
void initState() {
  super.initState();

  Future.microtask(() async {
    final hasPermission = await checkPermission();

    if (!mounted) return;

    if (hasPermission) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Container(child: Scaffold());
  }
}
