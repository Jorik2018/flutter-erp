import 'package:flutter_erp/apps/mylms/modules/course.dart';
import 'package:flutter_erp/apps/mylms/services/api/api_service.dart';

class CourseService {
  static Future<List<Course>> getMyCourses() async {
    List data = await ApiService.get('course/my');
    return data.map((e) => Course.fromJson(e)).toList();
  }
}
