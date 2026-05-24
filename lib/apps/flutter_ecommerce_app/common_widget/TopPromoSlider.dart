import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TopPromoSlider extends StatelessWidget {
  TopPromoSlider({super.key});

  final List<String> images = [
    "assets/images/promotion__one.png",
    // "assets/images/promotion_two.png",
    // "assets/images/promotion_three.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: false,
        ),
        items: images.map((imgPath) {
          return Builder(
            builder: (context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}