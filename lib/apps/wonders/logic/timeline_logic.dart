import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/common/string_utils.dart';
import 'package:flutter_erp/apps/wonders/logic/data/timeline_data.dart';

class TimelineLogic {
  final List<TimelineEvent> events = [];

  Future<void> init() async {
    events.addAll(GlobalEventsData().globalEvents);

    for (var w in wondersLogic.all) {
      events.add(
        TimelineEvent(
          w.startYr,
          /**error:The argument type 'String Function(Object)' can't be assigned to the parameter type 'String'. */
          StringUtils.supplant($strings.timelineLabelConstruction(w.title), {'{title}': w.title}),
        ),
      );
    }
  }
}
