import 'dart:math';

import 'package:flutter/material.dart';

class ScreenRatio {
  static bool initialized = false;
  static late double heightRatio;
  static late double widthRatio;
  static late double screenHeight;
  static late double absoluteHeight;
  static late double absoluteWidth;
  static late double screenWidth;
  static late double notchHeight;
  static late double fontRatio;
  static late double pixelRatio;

  static setScreenRatio(MediaQueryData mediaQueryData) {
    initialized = true;
    final Size size = mediaQueryData.size;
    notchHeight = mediaQueryData.padding.top;
    absoluteHeight = mediaQueryData.size.height;
    absoluteWidth = mediaQueryData.size.width;
    screenHeight = size.height - mediaQueryData.viewPadding.vertical;
    screenWidth = size.width - mediaQueryData.padding.horizontal;
    heightRatio = screenHeight / 896.0;
    widthRatio = screenWidth / 414.0;
    pixelRatio = mediaQueryData.devicePixelRatio;
    fontRatio = min(widthRatio, heightRatio);
  }
}
