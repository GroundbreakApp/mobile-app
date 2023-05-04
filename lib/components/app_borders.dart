import 'package:flutter/material.dart';

class AppBorders {
  static BorderRadius roundedBorder5 = BorderRadius.circular(5.0);
  static BorderRadius roundedBorder10 = BorderRadius.circular(10.0);
  static BorderRadius roundedBorder15 = BorderRadius.circular(15.0);
  static BorderRadius roundedBorder30TopOnly = const BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );
}
