import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/country_profile_name.dart';
import 'components/country_profile_warning.dart';

class CountryProfileItem extends StatelessObserverWidget {
  const CountryProfileItem({
    super.key,
    required this.onTap,
    required this.countryCode,
    required this.countryName,
    required this.isBlocked,
  });

  final Function() onTap;
  final String countryCode;
  final String countryName;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64.0,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: FlagItem(
                      countryCode: countryCode,
                    ),
                  ),
                  CountryProfileName(
                    countryName: countryName,
                    isBlocked: isBlocked,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: isBlocked,
                    child: const CountryProfileWarning(),
                  ),
                ],
              ),
              const Spacer(),
              const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
