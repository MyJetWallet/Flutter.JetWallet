import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';
import 'package:simple_kit/core/simple_kit.dart';

class FlagItem extends StatelessObserverWidget {
  const FlagItem({
    super.key,
    required this.countryCode,
  });

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 24,
      width: 24,
      child: (countryFlagExist(countryCode))
          ? SvgPicture.asset(
              flagAssetName(countryCode),
              fit: BoxFit.cover,
              height: 24,
              width: 24,
            )
          : Container(
              height: 24,
              width: 24,
              color: colors.grey4,
            ),
    );
  }
}
