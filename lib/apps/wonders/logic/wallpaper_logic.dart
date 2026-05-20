import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/common/platform_info.dart';
import 'package:flutter_erp/apps/wonders/ui/common/modals/app_modals.dart';

class WallPaperLogic {
  /// Walks user through flow to save a Wonder Poster to their gallery

Future<void> save(
  State state,
  RenderRepaintBoundary boundary, {
  required String name,
}) async {
  final context = state.context;

  Uint8List? pngBytes = await _getPngFromBoundary(boundary);

  if (pngBytes == null || !state.mounted) return;

  final bool? confirm = await showModal(
    context,
    child: OkCancelModal(msg: $strings.wallpaperModalSave),
  );

  if (confirm != true || !state.mounted) return;

  showModal(
    context,
    child: LoadingModal(msg: $strings.wallpaperModalSaving),
  );

  try {
    if (PlatformInfo.isMobile) {
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 95,
        name: name,
      );

      // opcional: validar resultado
      if (result == null || result['isSuccess'] != true) {
        throw Exception('Error saving image');
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!state.mounted) return;

    Navigator.pop(context); // cerrar loading

    showModal(
      context,
      child: OkModal(msg: $strings.wallpaperModalSaveComplete),
    );
  } catch (e) {
    if (!state.mounted) return;

    Navigator.pop(context);

    showModal(
      context,
      child: OkModal(msg: "Error saving image"),
    );
  }
}
  Future<void> share(
    BuildContext context,
    RenderRepaintBoundary boundary, {
    required String name,
    String wonderName = 'Wonderous',
  }) async {
    Uint8List? pngBytes = await _getPngFromBoundary(boundary);
    if (pngBytes != null) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$directory/$name.png');
      imgFile.writeAsBytes(pngBytes).then((_) async {
        SharePlus.instance
            .share(
              ShareParams(
                subject: '$wonderName Wallpaper',
                text:
                    'Check out this $wonderName wallpaper from the Wonderous app!',
                files: [XFile('$directory/$name.png', mimeType: 'image/png')],
              ),
            )
            .then((result) {
              if (result.status == ShareResultStatus.success) {
                print('Thank you for sharing the picture!');
              }
            });
      });
    }
  }
}

Future<Uint8List?> _getPngFromBoundary(RenderRepaintBoundary boundary) async {
  ui.Image uiImage = await boundary.toImage();
  ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
  if (byteData != null) {
    return byteData.buffer.asUint8List();
  }
  return null;
}
