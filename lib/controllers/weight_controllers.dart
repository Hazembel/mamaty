import 'package:flutter/foundation.dart';

class WeightControllers {
  double current = 0.0;

  void update(double value) {
    current = value;
    if (kDebugMode) {
      print('Current weight: $value');
    }
  }
}
