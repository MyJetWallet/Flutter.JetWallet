import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/utils/constants.dart';

class EmptyPortfolioBodyImage extends StatelessWidget {
  const EmptyPortfolioBodyImage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    return deviceSize.when(
      small: () {
        return Image.asset(
          earnImageAsset,
          height: 160,
        );
      },
      medium: () {
        return Image.asset(
          earnImageAsset,
          height: 280,
        );
      },
    );
  }
}
