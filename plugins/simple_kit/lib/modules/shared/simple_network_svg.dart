import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../simple_kit.dart';

class SNetworkSvg24 extends StatelessWidget {
  const SNetworkSvg24({
    Key? key,
    this.color,
    required this.url,
  }) : super(key: key);

  final Color? color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: 24.0,
      height: 24.0,
      color: color,
      placeholderBuilder: (_) {
        return const SAssetPlaceholderIcon();
      },
    );
  }
}

class SNetworkSvg extends StatelessWidget {
  const SNetworkSvg({
    Key? key,
    this.color,
    required this.url,
    required this.width,
    required this.height,
    this.placeholder,
  }) : super(key: key);

  final Color? color;
  final String url;
  final double width;
  final double height;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: width,
      height: height,
      color: color,
      placeholderBuilder: (_) {
        return placeholder ?? const SAssetPlaceholderIcon();
      },
    );
  }
}

class SNetworkCachedSvg extends StatelessWidget {
  const SNetworkCachedSvg({
    Key? key,
    this.color,
    required this.url,
    required this.width,
    required this.height,
    required this.placeholder,
  }) : super(key: key);

  final Color? color;
  final String url;
  final double width;
  final double height;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultCacheManager().getSingleFile(url),
      builder: (context, AsyncSnapshot<File> snapshot) {
        return snapshot.hasData
            ? SvgPicture.file(
                snapshot.data!,
                width: width,
                height: height,
                color: color,
                placeholderBuilder: (_) {
                  return placeholder;
                },
              )
            : placeholder;
      },
    );
  }
}
