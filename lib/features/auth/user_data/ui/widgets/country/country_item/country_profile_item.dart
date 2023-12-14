import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: needPadding ? 24.0 : 0.0,
        ),
        child: SizedBox(
          height: needPadding ? 68 : 29,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: needPadding ? 20.0 : 0,
                    ),
                    child: FlagItem(
                      countryCode: countryCode,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: needPadding ? 18.0 : 0,
                    ),
                    child: CountryProfileName(
                      countryName: countryName,
                      isBlocked: isBlocked,
                      needBaseline: false,
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: isBlocked,
                    child: const CountryProfileWarning(),
                  ),
                ],
              ),
              if (needPadding) ...[
                const Spacer(),
                const SDivider(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
