import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_erp/apps/mylms/modules/level.dart';
import 'package:flutter_erp/apps/mylms/modules/subject.dart';
import 'package:flutter_erp/models/user.dart' as app_user;

part 'course.g.dart';

@JsonSerializable()
class Course {
  int id;
  String title;
  String description;
  String? thumbnailURL;
  int duration;
  app_user.User lecturer;
  Level level;
  Subject subject;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.lecturer,
    required this.level,
    required this.subject,
    this.thumbnailURL,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
