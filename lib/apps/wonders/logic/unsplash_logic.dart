import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/data/unsplash_photo_data.dart';
import 'package:flutter_erp/apps/wonders/logic/unsplash_service.dart';

class UnsplashLogic {
  final Map<String, List<String>> _idsByCollection = UnsplashPhotoData.photosByCollectionId;

  UnsplashService get service => GetIt.I.get<UnsplashService>();

  List<String>? getCollectionPhotos(String collectionId) => _idsByCollection[collectionId];

}
