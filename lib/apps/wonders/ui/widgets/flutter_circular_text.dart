import 'dart:math';
import 'package:flutter/material.dart';

enum CircularTextPosition { inside, outside }
enum CircularTextDirection { clockwise, anticlockwise }
enum StartAngleAlignment { start, center }

class CircularText extends StatelessWidget {
  final CircularTextPosition position;
  final List<TextItem> children;
  final double radius;

  const CircularText({
    super.key,
    required this.children,
    this.position = CircularTextPosition.outside,
    this.radius = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircularTextPainter(children, position, radius),
      size: Size(radius * 2, radius * 2),
    );
  }
}

class TextItem {
  final Text text;
  final double space;
  final double startAngle;
  final StartAngleAlignment startAngleAlignment;
  final CircularTextDirection direction;

  TextItem({
    required this.text,
    this.space = 0,
    this.startAngle = 0,
    this.startAngleAlignment = StartAngleAlignment.start,
    this.direction = CircularTextDirection.clockwise,
  });
}

class _CircularTextPainter extends CustomPainter {
  final List<TextItem> items;
  final CircularTextPosition position;
  final double radius;

  _CircularTextPainter(this.items, this.position, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);

    for (final item in items) {
      final text = (item.text.data ?? "");
      final style = item.text.style ?? const TextStyle();

      double angle = _degToRad(item.startAngle);
      final isClockwise = item.direction == CircularTextDirection.clockwise;

      // Medir texto total (para centrar si aplica)
      final totalArc = _measureArc(text, style);

      if (item.startAngleAlignment == StartAngleAlignment.center) {
        angle -= totalArc / 2;
      }

      for (int i = 0; i < text.length; i++) {
        final char = text[i];

        final tp = TextPainter(
          text: TextSpan(text: char, style: style),
          textDirection: TextDirection.ltr,
        )..layout();

        final charWidth = tp.width;
        final charAngle = charWidth / radius;

        final drawRadius =
            position == CircularTextPosition.inside ? radius - tp.height : radius;

        final x = center.dx + drawRadius * cos(angle);
        final y = center.dy + drawRadius * sin(angle);

        canvas.save();
        canvas.translate(x, y);

        canvas.rotate(
          angle + (isClockwise ? pi / 2 : -pi / 2),
        );

        tp.paint(canvas, Offset(-charWidth / 2, -tp.height));

        canvas.restore();

        angle += (isClockwise ? 1 : -1) * (charAngle + item.space / radius);
      }
    }
  }

  double _measureArc(String text, TextStyle style) {
    double total = 0;
    for (var i = 0; i < text.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: text[i], style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      total += tp.width;
    }
    return total / radius;
  }

  double _degToRad(double deg) => deg * pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}