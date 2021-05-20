import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  final Widget mobilePage;
  final Widget tabletPage;
  final Widget desktopPage;
  static double mobilePageWidth = 850;
  static double tablePageWidth = 1100;

  ResponsivePage({Key key, this.mobilePage, this.tabletPage, this.desktopPage})
      : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobilePageWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tablePageWidth &&
      MediaQuery.of(context).size.width >= mobilePageWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablePageWidth;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= tablePageWidth) {
      return desktopPage;
    } else if (_size.width >= mobilePageWidth && tabletPage != null) {
      return tabletPage;
    } else {
      return mobilePage;
    }
  }
}
