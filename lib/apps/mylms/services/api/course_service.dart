import 'package:flutter_erp/apps/mylms/modules/course.dart';
import 'package:flutter_erp/apps/mylms/services/api/api_service.dart';

class CourseService {
  static Future<List<Course>> getMyCourses() async {
    return await ApiService.get<List<Course>>(
      'course/my',
      fromJson: (json) {
        return (json as List<dynamic>)
            .map((item) => Course.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
