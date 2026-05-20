import '../constants/assets.dart';

import 'price.dart';

class Furniture {

  final String? name;
  final String? description;
  final Price? price;
  final String? imageUrl;
  bool? selected;

  Furniture({
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.selected,
  });


  static List<Furniture> get list {
    return [
      Furniture(
        name: 'Georg Jensen Minimal Clock',
        description: 'some description',
        price: Price(
          mrp: 2990,
          currency: '₹',
        ),
        imageUrl: Assets.clockPng,
      ),
      Furniture(
        name: 'Teapot with black tea',
        description: 'some description',
        price: Price(
          mrp: 3999,
          currency: '₹',
        ),
        imageUrl: Assets.teapotWithBlackTeaPng,
      ),
      Furniture(
        name: 'Nancy Chair',
        description: 'some description',
        price: Price(
          mrp: 9999,
          currency: '₹',
        ),
        imageUrl: Assets.nancyChairPng,
      ),
      Furniture(
        name: 'Table Wood Pine',
        description: 'some description',
        price: Price(
          mrp: 5699,
          currency: '₹',
        ),
        imageUrl: Assets.tableWoodPinePng,
      ),
      Furniture(
        name: 'Product One',
        description: 'some description',
        price: Price(
          mrp: 5699,
          currency: '₹',
        ),
        imageUrl: Assets.productOnePng,
      ),
      Furniture(
        name: 'Product Two',
        description: 'some description',
        price: Price(
          mrp: 5699,
          currency: '₹',
        ),
        imageUrl: Assets.productTwoPng,
      ),
    ];
  }
}
