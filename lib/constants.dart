import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static Widget verticalGap(double height) => SizedBox(height: height);
  static Widget horizontalGap(double width) => SizedBox(width: width);
}
