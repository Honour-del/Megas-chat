import 'package:flutter/material.dart';

class SizeConfig {
  static  MediaQueryData _mediaQueryData;
  ///width of the screen its being projected on
  static double screenWidth;
  ///height of the screen its being projected on
  static double screenHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }
}
///gets the proportionate height in relation to the screen height
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight/896.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth/414.0) * screenWidth;
}