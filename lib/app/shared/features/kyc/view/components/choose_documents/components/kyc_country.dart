import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../components/flag_item.dart';
import '../../../../model/kyc_country_model.dart';
import '../../../../notifier/kyc_countries/kyc_countries_notipod.dart';

class KycCountry extends HookWidget {
  const KycCountry({
    Key? key,
    required this.activeCountry,
    required this.openCountryList,
  }) : super(key: key);

  final KycCountryModel activeCountry;
  final Function() openCountryList;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycCountriesNotipod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return InkWell(
      highlightColor: Colors.transparent,
      onTap: openCountryList,
      child: SPaddingH24(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 21,
              ),
              child: Row(
                children: [
                  Text(
                    intl.kycCountry_countryOfIssue,
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
                  FlagItem(
                    countryCode: state.activeCountry!.countryCode,
                  ),
                  const SpaceW10(),
                  Text(
                    state.activeCountry!.countryName,
                    style: sSubtitle2Style,
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
