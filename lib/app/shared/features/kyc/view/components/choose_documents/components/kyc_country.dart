import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifier/kyc_countries/kyc_countries_notipod.dart';

class KycCountry extends HookWidget {
  const KycCountry({
    Key? key,
    required this.openCountryList,
  }) : super(key: key);

  final Function() openCountryList;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycCountriesNotipod);
    final colors = useProvider(sColorPod);

    return InkWell(
      highlightColor: Colors.transparent,
      onTap: openCountryList,
      child: SPaddingH24(
        child: Column(
          children: [
            if (state.activeCountry != null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: 21,
                ),
                child: Row(
                  children: [
                    Text(
                      'Country of Issue',
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 21,
                ),
                child: Row(
                  children: [
                    Text(
                      state.activeCountry!.countryName,
                      style: sSubtitle2Style,
                    ),
                  ],
                ),
              ),
            ],
            if (state.activeCountry == null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 30,
                ),
                child: Row(
                  children: [
                    Text(
                      'Country of Issue',
                      style: sSubtitle2Style.copyWith(
                        color: colors.grey2,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
