import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../simple_kit.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SNetworkSvg24 extends StatelessWidget {
  const SNetworkSvg24({
    super.key,
    this.color,
    required this.url,
  });

  final Color? color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: 24.0,
      height: 24.0,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      placeholderBuilder: (_) {
        return const SAssetPlaceholderIcon();
      },
    );
  }
}

class SNetworkSvg extends StatelessWidget {
  const SNetworkSvg({
    super.key,
    this.color,
    required this.url,
    required this.width,
    required this.height,
    this.placeholder,
  });

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
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      placeholderBuilder: (_) {
        return placeholder ?? const SAssetPlaceholderIcon();
      },
    );
  }
}

class SNetworkCachedSvg extends StatelessWidget {
  const SNetworkCachedSvg({
    super.key,
    this.color,
    required this.url,
    required this.width,
    required this.height,
    required this.placeholder,
  });

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
                colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
                placeholderBuilder: (_) {
                  return placeholder;
                },
              )
            : placeholder;
      },
    );
  }
}
