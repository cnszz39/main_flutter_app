import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  final Widget mobilePage;
  final Widget tabletPage;
  final Widget desktopPage;

  ResponsivePage({Key key, this.mobilePage, this.tabletPage, this.desktopPage})
      : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1100) {
      return desktopPage;
    } else if (_size.width >= 850 && tabletPage != null) {
      return tabletPage;
    } else {
      return mobilePage;
    }
  }
}
