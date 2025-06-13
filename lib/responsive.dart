import 'package:flutter/widgets.dart';

double getHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getResponsive(context) {
  return MediaQuery.of(context).size.height * 0.001;
}

double getResponsiveTextSize(context) {
  // if (PLatform.Android) {
  //   return 0.8;
  // }  else {
  //   return 0.9;
  // }
  return 0.8;
}
