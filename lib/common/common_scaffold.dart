import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final String strTitle;
  final Widget bodyWidget;
  final List<Widget> appBarActions;
  final Color backgroundColor;

  CommonScaffold({
    this.strTitle,
    this.bodyWidget,
    this.appBarActions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(strTitle.isNotEmpty ? strTitle : ''),
        actions: appBarActions,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 8.0, left: 8.0),
        child: bodyWidget,
      ),
    );
  }
}
