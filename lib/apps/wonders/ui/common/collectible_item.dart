import 'package:get_it/get_it.dart';
import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/logic/collectibles_logic.dart';
import 'package:flutter_erp/apps/wonders/logic/data/collectible_data.dart';
import 'package:flutter_erp/apps/wonders/ui/common/cards/opening_card.dart';
import 'package:flutter_erp/apps/wonders/ui/common/utils/app_haptics.dart';
import 'package:flutter_erp/apps/wonders/ui/screens/collectible_found/collectible_found_screen.dart';

/**error:Classes can only mix in mixins and classes. */
class CollectibleItem extends StatelessWidget {
  final CollectibleData collectible;

  final double size;

  late final ImageProvider _imageProvider;

  CollectibleItem(this.collectible, {this.size = 64.0, Key? key})
    : super(key: key) {
    // pre-fetch the image, so it's ready if we show the collectible found screen.
    _imageProvider = NetworkImage(collectible.imageUrlSmall);
    _imageProvider
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((_, __) {}));
  }

  void _handleTap(BuildContext context) async {
    final screen = CollectibleFoundScreen(
      collectible: collectible,
      imageProvider: _imageProvider,
    );
    appLogic.showFullscreenDialogRoute(context, screen);
    AppHaptics.mediumImpact();

    // wait to update the state, to ensure the hero works properly:
    await Future.delayed($styles.times.pageTransition);
    collectiblesLogic.updateState(collectible.id, CollectibleState.discovered);
  }

  @override
  Widget build(BuildContext context) {
    
    final collectiblesLogic = GetIt.instance<CollectiblesLogic>();
    
    final states = collectiblesLogic.statesById;

    bool isLost = states.value[collectible.id] == CollectibleState.lost;
    // Use an OpeningCard to let the collectible smoothly collapse its size once it has been found
    return SizedBox(
      height: isLost ? size : null,
      child: RepaintBoundary(
        child: OpeningCard(
          isOpen: isLost,
          // Note: In order for the collapse animation to run properly, we must return a non-zero height or width.
          closedBuilder: (_) => SizedBox(width: 1, height: 0),
          openBuilder: (_) => AppBtn.basic(
            semanticLabel: $strings.collectibleItemSemanticCollectible,
            onPressed: () => _handleTap(context),
            enableFeedback: false,
            child:
                Hero(
                      tag: 'collectible_icon_${collectible.id}',
                      child: Image(
                        image: collectible.icon,
                        width: size,
                        height: size,
                        fit: BoxFit.contain,
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    // TODO SB (Aug 17, 2022): Temporarily removed on Jonahs request, due to a bug in Impeller which should be fixed soon. Re-enable when fixed.
                    //.shimmer(delay: 4000.ms, duration: $styles.times.med * 3)
                    .shake(
                      delay: 4000.ms,
                      duration: $styles.times.med * 3,
                      curve: Curves.easeInOutCubic,
                      hz: 4,
                    )
                    /**errpr:The argument type 'double' can't be assigned to the parameter type 'Offset?'. */
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.1, 1.1),
                      duration: $styles.times.med,
                    )
                    .then(delay: $styles.times.med)
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1 / 1.1, 1 / 1.1),
                    ),
          ),
        ),
      ),
    );
  }
}
