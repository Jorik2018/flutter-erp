import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class FoodDetailsSlider extends StatelessWidget {
  String? slideImage1;
  String? slideImage2;
  String? slideImage3;

  FoodDetailsSlider(
      {Key? key,
      @required this.slideImage1,
      @required this.slideImage2,
      @required this.slideImage3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
          child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.asset(
                slideImage1!,
              );
        },
        itemCount: 3,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      ),
    )

    );
  }
}
