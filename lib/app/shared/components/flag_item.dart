import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../helpers/flag_asset_name.dart';

class FlagItem extends HookWidget {
  const FlagItem({
    Key? key,
    required this.countryCode,
  }) : super(key: key);

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 24,
      width: 24,
      child: (countryFlagExist(countryCode)) ? SvgPicture.asset(
        flagAssetName(countryCode),
        fit: BoxFit.cover,
        height: 24,
        width: 24,
      ) : Container(
        height: 24,
        width: 24,
        color: colors.grey4,
      ),
    );
  }
}
