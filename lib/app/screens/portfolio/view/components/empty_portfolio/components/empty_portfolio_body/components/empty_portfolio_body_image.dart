import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../../shared/constants.dart';
import '../../../../../../../../../shared/providers/device_size/device_size_pod.dart';

class EmptyPortfolioBodyImage extends HookWidget {
  const EmptyPortfolioBodyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);

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
