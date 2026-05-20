import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/ui/common/controls/app_loading_indicator.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FullscreenVideoPage extends StatefulWidget {
  const FullscreenVideoPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  late final _controller = YoutubePlayerController.fromVideoId(
    videoId: widget.id,
    autoPlay: true,
    startSeconds: 1
  );

  @override
  void initState() {
    super.initState();
    appLogic.setDeviceOrientation(null);
  }

  @override
  void dispose() {
    appLogic.setDeviceOrientation(Axis.vertical);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /**The getter 'isLandscape' isn't defined for the type 'BuildContext'.
Try importing the library that defines 'isLandscape', correcting the name to the name of an existing getter, or defining a getter or field named 'isLandscape'. */
    double aspect = MediaQuery.of(context).orientation == Orientation.landscape
    ? MediaQuery.of(context).size.aspectRatio
    : 1;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: aspect,
              child: Stack(
                children: [
                  const Center(child: AppLoadingIndicator()),
                  YoutubePlayer(
                    controller: _controller,
                    aspectRatio: aspect,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all($styles.insets.md),
              child: const BackBtn(),
            ),
          ),
        ],
      ),
    );
  }
}
