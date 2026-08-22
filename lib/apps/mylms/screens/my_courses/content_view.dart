import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/mylms/modules/content.dart';
import 'package:flutter_erp/apps/mylms/modules/course.dart';
import 'package:flutter_erp/apps/mylms/screens/my_courses/single_content_view.dart';
import 'package:flutter_erp/apps/mylms/screens/my_courses/submission_view.dart';
import 'package:flutter_erp/apps/mylms/services/api/content_service.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContentView extends StatelessWidget {
  final Course course;

  const ContentView({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: FutureBuilder<List<Content>>(
        future: ContentService.getContentByCourseID(course.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          }

          final contents = snapshot.data ?? [];

          if (contents.isEmpty) {
            return const Center(child: Text('No content available'));
          }

          return Timeline.tileBuilder(
            builder: TimelineTileBuilder.fromStyle(
              contentsAlign: ContentsAlign.basic,
              itemCount: contents.length,
              oppositeContentsBuilder: (context, index) {
                final item = contents[index];

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_formatDate(item.addedDate)),
                );
              },
              contentsBuilder: (context, index) {
                final item = contents[index];

                final icon = switch (item.type) {
                  'Assignment' => Icons.upload_file,
                  'Announcement' => Icons.announcement,
                  _ => Icons.file_copy,
                };

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: ListTile(
                    leading: Icon(icon),
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    onTap: () {
                      if (item.type == 'Assignment') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubmissionView(content: item),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SingleContentView(content: item),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    return timeago.format(date);
  }
}
