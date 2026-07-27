import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/tourism_demo/clippers.dart';
import 'package:flutter_erp/apps/tourism_demo/i18n/translations.dart';
import 'package:flutter_erp/apps/tourism_demo/networking/server_api.dart';
import 'package:flutter_erp/apps/tourism_demo/styles/app_colors.dart';
import 'package:flutter_erp/apps/tourism_demo/ui/destinations/destination_list_tile.dart';
import 'package:flutter_erp/apps/tourism_demo/utils.dart';

class DestinationInfoView extends StatefulWidget {
  DestinationInfoView();

  @override
  State<StatefulWidget> createState() {
    return _DestinationInfoState();
  }
}

class _DestinationInfoState extends State<DestinationInfoView>
    with TickerProviderStateMixin {
  _DestinationInfoState();

  DestinationCard? destinationCard;
  AnimationController? locationsAnimationController;
  AnimationController? servicesAnimationController;
  Animation<double>? servicesInfoAnimation;
  Animation<double>? locationsAnimation;

  @override
  initState() {
    locationsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    servicesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    var curvedAnimation = CurvedAnimation(
      parent: locationsAnimationController!,
      curve: Curves.fastOutSlowIn,
    );
    var curvedAnimation2 = CurvedAnimation(
      parent: servicesAnimationController!,
      curve: Curves.fastOutSlowIn,
    );

    servicesInfoAnimation =
        Tween<double>(begin: 90.0, end: 180.0).animate(curvedAnimation)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          });

    servicesInfoAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        servicesAnimationController!.forward();
      } else if (status == AnimationStatus.dismissed) {
        //  todo: needs enhancements
        Navigator.pop(context);
      }
    });
    locationsAnimation =
        Tween<double>(begin: 270.0, end: 180.0).animate(curvedAnimation2)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          });
    locationsAnimation!.addStatusListener((status) {
      debugPrint('status: $status');
      if (status == AnimationStatus.dismissed) {
        locationsAnimationController!.reverse();
      }
    });

    locationsAnimationController!.forward();
    super.initState();
  }

  _collapseAnimations() {
    servicesAnimationController!.reverse();
  }

  Widget _imageAndDesc(String image, String desc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 32.0,
            width: 32.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Text(
            desc,
            style: TextStyle(
              color: AppColors.tertiaryTextColor,
              fontSize: 17.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesInfo(
    BuildContext context,
    double degrees,
    AlignmentGeometry alignment,
  ) {
    bool isAr = true; //StoreProvider.of<AppState>(context).state.isAr;

    return Transform(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ClipPath(
          clipper: NotchedClipper(),
          child: Container(
            decoration: cardGradientBackground(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              child: Column(
                children: <Widget>[
                  _imageAndDesc(
                    'images/icons/airplane(1).png',
                    isAr
                        ? destinationCard!.destination!.airlinesAr!
                        : destinationCard!.destination!.airlines!,
                  ),
                  _imageAndDesc(
                    'images/icons/food.png',
                    isAr
                        ? destinationCard!.destination!.foodAr!
                        : destinationCard!.destination!.food!,
                  ),
                  _imageAndDesc(
                    'images/icons/hotel.png',
                    isAr
                        ? '${Translations.of(context).hotels} ${destinationCard!.destination!.hotelStars}' +
                              ' ${Translations.of(context).star}'
                        : '${destinationCard!.destination!.hotelStars}-${Translations.of(context).star}' +
                              '${Translations.of(context).hotels}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      alignment: alignment,
      transform: perspective.scaled(1.0, 1.0, 1.0)
        ..rotateX(math.pi - degrees * math.pi / 180)
        ..rotateY(0.0)
        ..rotateZ(0.0),
    );
  }

  Widget _buildLocations(BuildContext context) {
    bool isAr = true; //StoreProvider.of<AppState>(context).state.isAr;

    if (destinationCard!.destination!.activities!.length > 0) {
      return SizedBox(
        height: 120.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: destinationCard!.destination!.activities!
              .map(
                (d) => (Column(
                  children: <Widget>[
                    Container(
                      width: 75.0,
                      height: 75.0,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      ),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'images/placeholder.png',
                          fit: BoxFit.cover,
                          image: d.photo != null
                              ? d.photo!.replaceAll('~', ServerAPI.host)
                              : 'images/placeholder.png',
                        ),
                      ),
                    ),
                    Text(
                      isAr ? d.cityAr! : d.city!,
                      style: TextStyle(
                        color: AppColors.tertiaryTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                  // onTapped: () => _openEventDetails(context, d),
                )),
              )
              .toList(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildLocationsInfo(
    BuildContext context,
    double degrees,
    AlignmentGeometry alignment,
  ) {
    return Transform(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ClipPath(
          clipper: NotchedClipper(
            bottomLeft: false,
            bottomRight: false,
            topLeft: true,
            topRight: true,
          ),
          //      clipper: BottomWaveClipper(),
          child: Container(
            decoration: cardGradientBackground(),
            //        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 15.0,
              ),
              child: _buildLocations(context),
            ),
          ),
        ),
      ),
      alignment: alignment,
      transform: perspective.scaled(1.0, 1.0, 1.0)
        ..rotateX(math.pi - degrees * math.pi / 180)
        ..rotateY(0.0)
        ..rotateZ(0.0),
    );
  }

  Widget buildInfo() {
    final double _height = MediaQuery.of(context).size.height;

    return Container(
      child: Hero(
        tag: "destinationCard!.destination!.photo!",
        child: destinationCard!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*destinationCard = StoreProvider.of<AppState>(
      context,
    ).state.destinationInfoState!.destinationCard!;*/

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(decoration: gradientBackDecoration()),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 30.0,
                  offset: const Offset(0.0, 75.0),
                ),
              ],
            ),
            child: infoInScrollView(context),
          ),
        ),
      ],
    );
  }

  CustomScrollView infoInScrollView(BuildContext context) {
    return CustomScrollView(
      // physics:PageScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          pinned: false,
          snap: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => _collapseAnimations(),
            child: Icon(Icons.arrow_back),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              buildInfo(),
              /* _buildServicesInfo(context, servicesInfoAnimation!.value,
                  FractionalOffset.topCenter),
              _buildLocationsInfo(context, locationsAnimation!.value,
                  FractionalOffset.topCenter),*/
            ]),
          ),
        ),
      ],
    );
  }

  dispose() {
    locationsAnimationController!.dispose();
    servicesAnimationController!.dispose();

    super.dispose();
  }
}
