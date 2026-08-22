import 'package:flutter_erp/apps/mylms/services/api/api_service.dart';

class SubmissionServices {
  static Future<void> submit(int contentID, String filePath) async {
    await ApiService.fileUpload("submission/$contentID", filePath);
  }
}
