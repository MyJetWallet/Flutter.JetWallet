import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';

class FlagItem extends StatelessObserverWidget {
  const FlagItem({
    super.key,
    required this.countryCode,
  });

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 20,
      width: 20,
      child: (countryFlagExist(countryCode))
          ? SvgPicture.asset(
              flagAssetName(countryCode),
              fit: BoxFit.cover,
              height: 20,
              width: 20,
            )
          : Container(
              height: 20,
              width: 20,
              color: colors.gray4,
            ),
    );
  }
}
