import 'dart:math' as math;

class Rnd {
  final math.Random _r;

  Rnd([int? seed]) : _r = math.Random(seed);

  /// número entre min y max
  double getDouble(double min, double max) {
    return min + _r.nextDouble() * (max - min);
  }

  /// entero entre min y max
  int getInt(int min, int max) {
    return min + _r.nextInt(max - min);
  }

  /// boolean random
  bool getBool() {
    return _r.nextBool();
  }

  /// ángulo en radianes (0 - 2π)
  double getRad() {
    return _r.nextDouble() * 2 * math.pi;
  }

  /// call style: rnd(0.5, 1)
  double call(double min, double max) {
    return getDouble(min, max);
  }
}

final rnd = Rnd();