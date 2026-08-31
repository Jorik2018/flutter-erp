import 'package:flutter_erp/apps/mylms/modules/content.dart';
import 'package:flutter_erp/apps/mylms/services/api/api_service.dart';

class ContentService {
  static Future<List<Content>> getContentByCourseID(int id) {
    return ApiService.get<List<Content>>(
      'content/$id',
      fromJson: (json) {
        return (json as List<dynamic>)
            .map((item) => Content.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
