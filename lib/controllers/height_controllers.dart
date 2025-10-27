import 'package:flutter/foundation.dart';

class HeightControllers {
  final ValueNotifier<double> height = ValueNotifier<double>(30);

  double get current => height.value;
  set current(double value) => height.value = value;
}
