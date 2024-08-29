import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class NetworkIconWidget extends StatelessWidget {
  const NetworkIconWidget(this.iconUrl, {
    this.height = 24.0,
    this.width = 24.0,
    super.key,
  });

  final String iconUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: iconUrl,
      fit: BoxFit.cover,
      height: height,
      width: width,
      fadeInDuration: const Duration(milliseconds: 50),
      fadeOutDuration: const Duration(milliseconds: 50),
      placeholder: (context, url) => const SAssetPlaceholderIcon(),
      errorWidget: (context, url, error) => const SAssetPlaceholderIcon(),
    );
  }
}
