import 'package:flutter/material.dart';

class Service {
  final int id;
  final String title, image;
  final Color color;

  Service({required this.id, required this.title, required this.image, required this.color});
}

// For demo list of service
List<Service> services = [
  Service(
    id: 1,
    title: "Mobile App Development",
    image: "assets/images/mobile.webp",
    color: Color(0xFFD9FFFC),
  ),
  Service(
    id: 2,
    title: "Website Development",
    image: "assets/images/desktop.webp",
    color: Color(0xFFE4FFC7),
  ),
  Service(
    id: 3,
    title: "Building Rest APIs.",
    image: "assets/images/api.webp",
    color: Color(0xFFFFE0E0),
  ),
  Service(
    id: 4,
    title: "UI Design",
    image: "assets/images/ui.webp",
    color: Color(0xFFFFF3DD),
  ),
];
