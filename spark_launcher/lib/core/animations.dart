import 'package:flutter/material.dart';
import 'constants.dart';

class SparkAnimations {
  static const Curve defaultCurve = Curves.easeOut;
  static const Curve sparkExpandCurve = Curves.easeOutCubic;
  static const Curve drawerCurve = Curves.easeIn;

  static Duration get fast => const Duration(milliseconds: AppConstants.durationFast);
  static Duration get medium => const Duration(milliseconds: AppConstants.durationMedium);
  static Duration get slow => const Duration(milliseconds: AppConstants.durationSlow);
}
