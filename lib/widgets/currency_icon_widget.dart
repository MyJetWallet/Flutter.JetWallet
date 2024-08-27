import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';

class CurrencyIconWidget extends StatelessWidget {
  const CurrencyIconWidget(
    this.iconUrl, {
    this.height = 24.0,
    this.width = 24.0,
    super.key,
  });

  final String iconUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (iconUrl.contains('.svg')) {
      iconWidget = SNetworkSvg(
        url: iconUrl,
        height: height,
        width: width,
      );
    } else {
      iconWidget = CachedNetworkImage(
        imageUrl: iconUrl,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => SSkeletonLoader(
          height: height,
          width: width,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        errorWidget: (context, url, error) => const SizedBox(),
      );
    }

    return iconWidget;
  }
}
