import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  final String strImageUrl;
  final bool isLocalImage;

  ImageViewPage({this.strImageUrl, this.isLocalImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[400],
      appBar: AppBar(
        backgroundColor: Colors.brown[400].withOpacity(0),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: isLocalImage
            ? Image.asset(strImageUrl)
            : Image.network(strImageUrl),
      ),
    );
  }
}
