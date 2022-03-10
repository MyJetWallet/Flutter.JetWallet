import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../components/flag_item.dart';

class CountrySelectorButton extends HookWidget {
  const CountrySelectorButton({
    Key? key,
    required this.country,
    required this.onTap,
  }) : super(key: key);

  final SPhoneNumber country;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

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
                        'Country',
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
