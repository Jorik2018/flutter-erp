import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/common/string_utils.dart';
import 'package:flutter_erp/apps/wonders/logic/data/wonder_data.dart';
import 'package:flutter_erp/apps/wonders/ui/common/app_backdrop.dart';
import 'package:flutter_erp/apps/wonders/ui/common/compass_divider.dart';
import 'package:flutter_erp/apps/wonders/ui/common/curved_clippers.dart';
import 'package:flutter_erp/apps/wonders/ui/common/hidden_collectible.dart';
import 'package:flutter_erp/apps/wonders/ui/common/list_gradient.dart';
import 'package:flutter_erp/apps/wonders/ui/common/themed_text.dart';
import 'package:flutter_erp/apps/wonders/ui/common/timeline_event_card.dart';
import 'package:flutter_erp/apps/wonders/ui/common/wonders_timeline_builder.dart';
import 'package:flutter_erp/apps/wonders/ui/wonder_illustrations/common/wonder_title_text.dart';

part 'widgets/_events_list.dart';
part 'widgets/_top_content.dart';

class WonderEvents extends StatelessWidget {
  static const double _topHeight = 450;
  WonderEvents({Key? key, required this.type}) : super(key: key);
  final WonderType type;
  late final _data = wondersLogic.getData(type);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Container(
        color: $styles.colors.black,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              /// Top content, sits underneath scrolling list
              _TopContent(data: _data),

              /// Scrolling Events list, takes up the full view
              _EventsList(data: _data),
            ],
          ),
        ),
      );
    });
  }
}
