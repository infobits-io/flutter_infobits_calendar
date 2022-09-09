// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget laptop;
  final Widget desktop;

  const ResponsiveLayout(
      {Key? key,
      required this.mobile,
      required this.tablet,
      required this.laptop,
      required this.desktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        if (width < ScreenSizes.Mobile) {
          return mobile;
        } else if (width < ScreenSizes.Tablet) {
          return tablet;
        } else if (width < ScreenSizes.Laptop) {
          return laptop;
        } else {
          return desktop;
        }
      },
    );
  }
}

class ScreenSizes {
  static const int Mobile = 500;
  static const int Tablet = 800;
  static const int Laptop = 1000;
  static const int Desktop = 1200;

  static isMobile(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < ScreenSizes.Mobile;
  }

  static isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < ScreenSizes.Tablet;
  }

  static isLaptop(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < ScreenSizes.Laptop;
  }
}
