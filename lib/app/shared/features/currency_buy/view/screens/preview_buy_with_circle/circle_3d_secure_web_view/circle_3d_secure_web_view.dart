import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class Circle3dSecureWebView extends StatelessWidget {
  const Circle3dSecureWebView(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Text(url),
    );
  }
}
