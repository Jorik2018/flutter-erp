import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_erp/apps/video_watermark/controllers/CameraProvider.dart';
import 'package:flutter_erp/apps/video_watermark/controllers/VideoProvider.dart';
import 'package:flutter_erp/apps/video_watermark/Splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VideoProvider>(create: (_) => VideoProvider()),
        ChangeNotifierProvider<CameraProvider>(create: (_) => CameraProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
