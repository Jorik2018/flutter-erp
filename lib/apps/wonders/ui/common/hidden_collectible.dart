import 'package:get_it/get_it.dart';
import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/collectibles_logic.dart';
import 'package:flutter_erp/apps/wonders/ui/common/collectible_item.dart';

/// Shows a [CollectibleItem], for a specific set of wonders.
/// The item is looked up via index, and expects that 3 items always exist for each wonder.
/// If `wonders` is empty, then the collectible is always shown.
class HiddenCollectible extends StatelessWidget {
  HiddenCollectible(this.currentWonder, {Key? key, required this.index, this.matches = const [], this.size = 64})
      : assert(index <= 2, 'index should not exceed 2'),
        super(key: key);
  final int index;
  final double size;
  final List<WonderType> matches;
  final WonderType currentWonder;
  @override
  Widget build(BuildContext context) {
    /**The name 'CollectiblesLogic' isn't a type, so it can't be used as a type argument.
Try correcting the name to an existing type, or defining a type named 'CollectiblesLogic' */
    final collectiblesLogic = GetIt.instance<CollectiblesLogic>();
    final data = collectiblesLogic.forWonder(currentWonder);
    assert(data.length == 3, 'Each wonder should have exactly 3 collectibles');
    if (matches.isNotEmpty && matches.contains(currentWonder) == false) {
      return SizedBox.shrink();
    }
    return CollectibleItem(data[index], size: size);
  }
}
