import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

// value "a" edited to avoid extra bounce in the animation
class CustomCurveIn extends Curve {
  final double a = 0.0;

  final double b = -0.55;

  final double c = 0.265;

  final double d = 1.55;

  static const double _cubicErrorBound = 0.001;

  // modified to soft the bounce
  double _evaluateCubic(double a, double b, double m) {
    return 3 * a * (1 - m) * (1 - m) * m +
        3 * b * (1 - m) * m * m +
        m * m * m * m;
  }

  @override
  double transformInternal(double t) {
    double start = 0.0;
    double end = 1.0;
    while (true) {
      final double midpoint = (start + end) / 2;
      final double estimate = _evaluateCubic(a, c, midpoint);
      if ((t - estimate).abs() < _cubicErrorBound)
        return _evaluateCubic(b, d, midpoint);
      if (estimate < t)
        start = midpoint;
      else
        end = midpoint;
    }
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'Cubic')}(${a.toStringAsFixed(2)}, ${b.toStringAsFixed(2)}, ${c.toStringAsFixed(2)}, ${d.toStringAsFixed(2)})';
  }
}

class CustomCurveOut extends Curve {
  const CustomCurveOut([this.period = 0.4]);

  final double period;

  @override
  double transformInternal(double t) {
    final double s = period / 4.0;
    final modifier = 1;
    t = t - 1;
    return -math.pow(2.5, 10.0 * t) *
        math.sin((t - s) * (math.pi * modifier) / period);
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'CustomCurveOut')}($period)';
  }
}
