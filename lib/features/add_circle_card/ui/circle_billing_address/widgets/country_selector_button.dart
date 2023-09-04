import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';

class CountrySelectorButton extends StatelessObserverWidget {
  const CountrySelectorButton({
    super.key,
    required this.country,
    required this.onTap,
  });

  final SPhoneNumber country;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Material(
      color: colors.white,
      child: InkWell(
        highlightColor: colors.grey4,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: SPaddingH24(
          child: SizedBox(
            height: 88.0,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH22(),
                      Text(
                        intl.countrySelectorButton_country,
                        style: sCaptionTextStyle.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                      Row(
                        children: [
                          FlagItem(
                            countryCode: country.isoCode,
                          ),
                          const SpaceW10(),
                          Baseline(
                            baseline: 20.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              country.countryName,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
