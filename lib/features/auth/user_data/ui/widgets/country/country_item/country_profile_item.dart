import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/widgets/flag_item.dart';

import 'components/country_profile_name.dart';
import 'components/country_profile_warning.dart';

class CountryProfileItem extends StatelessObserverWidget {
  const CountryProfileItem({
    super.key,
    this.onTap,
    required this.countryCode,
    required this.countryName,
    required this.isBlocked,
    this.needPadding = true,
  });

  final Function()? onTap;
  final String countryCode;
  final String countryName;
  final bool isBlocked;

  final bool needPadding;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      highlightColor: colors.gray2,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: needPadding ? 24.0 : 0.0,
          vertical: 18,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlagItem(
              countryCode: countryCode,
            ),
            CountryProfileName(
              countryName: countryName,
              isBlocked: isBlocked,
            ),
            Visibility(
              visible: isBlocked,
              child: const CountryProfileWarning(),
            ),
          ],
        ),
      ),
    );
  }
}
