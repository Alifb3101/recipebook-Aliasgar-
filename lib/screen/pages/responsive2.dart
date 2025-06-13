import 'package:flutter/material.dart';

class Responsive {
  static int getCrossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  static double getChildAspectRatio(double width) {
    if (width >= 1200) return 0.95;
    if (width >= 900) return 0.9;
    if (width >= 600) return 0.85;
    return 0.95;
  }
}