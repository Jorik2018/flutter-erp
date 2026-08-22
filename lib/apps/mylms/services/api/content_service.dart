import 'package:flutter_erp/apps/mylms/modules/content.dart';
import 'package:flutter_erp/apps/mylms/services/api/api_service.dart';

class ContentService {
  static Future<List<Content>> getContentByCourseID(int id) async {
    List data = await ApiService.get("content/$id");
    return data.map((e) => Content.fromJson(e)).toList();
  }
}
