import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';

class KycCountry extends StatelessObserverWidget {
  const KycCountry({
    super.key,
    required this.activeCountry,
    required this.openCountryList,
  });

  final KycCountryModel activeCountry;
  final Function() openCountryList;

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<KycCountryStore>();
    final colors = sKit.colors;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: openCountryList,
      child: SPaddingH24(
        child: Row(
          children: [
            Column(
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
            const Spacer(),
            const SAngleDownIcon(),
          ],
        ),
      ),
    );
  }
}
