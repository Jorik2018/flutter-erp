import 'package:flutter/material.dart';
import '../../classes/plant.dart';
import '../fullscreen_image_page.dart';

class PlantPreview extends StatelessWidget {
  final Plant plant;
  PlantPreview(this.plant);

  final LinearGradient backgroundGradient = new LinearGradient(
    colors: [
      new Color(0x10000000), // Light black
      new Color(0x30000000), // Dark black
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: 0.0,
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (_) => new FullscreenImagePage('res/' + plant.plantImg),
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(14.0),
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              new SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(gradient: backgroundGradient),
                ),
              ),
              new Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: 'res/' + plant.plantImg,
                  child: Image.asset('res/${plant.plantImg}'),
                ),
              ),
              new Align(
                alignment: Alignment.bottomLeft,
                child: Material(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14.0),
                  ),
                  color: Colors.black,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      plant.plantName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.topRight,
                child: Material(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14.0),
                  ),
                  color: Colors.green,
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    child: Text(
                      plant.price - plant.price.truncate() > 0
                          ? '\$${plant.price.toStringAsFixed(2)}'
                          : '\$${plant.price.truncate()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
