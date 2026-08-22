import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/common/components/sliding_bottom_sheet.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/common/widgets/blur_icon.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/utils/parallax_page_view.dart';
import 'package:flutter_erp/apps/flutterhotelbookingapp/utils/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import 'package:rect_getter/rect_getter.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String heroTag;
  final String imageAsset;

  PlaceDetailScreen({required this.heroTag, required this.imageAsset});

  @override
  _PlaceDetailScreenState createState() =>
      _PlaceDetailScreenState(heroTag: heroTag, imageAsset: imageAsset);
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with SingleTickerProviderStateMixin {
  final String heroTag;
  final String imageAsset;
  final double bottomSheetCornerRadius = 50;

  final Duration animationDuration = Duration(milliseconds: 600);
  final Duration delay = Duration(milliseconds: 300);
  //GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect? rect;

  _PlaceDetailScreenState({required this.heroTag, required this.imageAsset});

  static double bookButtonBottomOffset = -60;
  double bookButtonBottom = bookButtonBottomOffset;
  late AnimationController _bottomSheetController;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    Future.delayed(Duration(milliseconds: 700)).then((v) {
      setState(() {
        bookButtonBottom = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ApplicationThemeProvider.get();
    final coverImageHeightCalc =
        MediaQuery.of(context).size.height / 3 + bottomSheetCornerRadius;
    return WillPopScope(
      onWillPop: () async {
        if (_bottomSheetController.value <= 0.5) {
          setState(() {
            bookButtonBottom = bookButtonBottomOffset;
          });
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(),
            Hero(
              createRectTween: ParallaxPageView.createRectTween,
              tag: heroTag,
              child: Container(
                height: coverImageHeightCalc,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: WormEffect(
                      spacing: 12,
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: themeData.indicatorColor,
                      activeDotColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 46,
              right: 24,
              child: Hero(
                tag: "${heroTag}heart",
                child: BlurIcon(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 15.2,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 46,
              left: 24,
              child: Hero(
                tag: "${heroTag}chevron",
                child: GestureDetector(
                  onTap: () async {
                    await _bottomSheetController.animateTo(
                      0,
                      duration: Duration(milliseconds: 150),
                    );
                    setState(() {
                      bookButtonBottom = bookButtonBottomOffset;
                    });
                    Navigator.pop(context);
                  },
                  child: BlurIcon(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width / 2,
              child: Align(
                alignment: Alignment.center,
                child: Text("Hello ABC"),
              ),
            ),
            SlidingBottomSheet(
              controller: _bottomSheetController,
              cornerRadius: bottomSheetCornerRadius,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ripple(ThemeData themeData) {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect!.left,
      right: MediaQuery.of(context).size.width - rect!.right,
      top: rect!.top,
      bottom: MediaQuery.of(context).size.height - rect!.bottom,
      child: Container(decoration: BoxDecoration(shape: BoxShape.circle)),
    );
  }
}
