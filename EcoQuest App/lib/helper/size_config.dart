import 'dart:math';
import 'package:flutter/cupertino.dart';


class SizeConfig {
  static MediaQueryData _mediaQueryData = MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double heightPercentage(double percentage){
    return (percentage * screenHeight)/100;
  }

  static double widthPercentage(double percentage){
    return (percentage * screenWidth)/100;
  }

  static double minPercentage(double percentage){
    return (percentage * min(screenHeight, screenWidth))/100;
  }
}