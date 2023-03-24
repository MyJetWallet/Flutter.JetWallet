import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/public/simple_secondary_button_1.dart';
import 'package:simple_kit/modules/icons/24x24/public/info/simple_info_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../utils/constants.dart';
import '../../kyc/kyc_service.dart';
import 'iban_item.dart';

class IBanBody extends StatelessObserverWidget {
  const IBanBody({
    Key? key,
    required this.name,
    required this.iban,
    required this.bic,
  }) : super(key: key);

  final String name;
  final String iban;
  final String bic;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceH30(),
          SPaddingH24(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      ibanEuroAsset,
                      width: 80,
                    ),
                    const SpaceW20(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intl.iban_euro,
                          style: sTextH5Style,
                        ),
                        const SpaceH10(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 188,
                          child: Text(
                            intl.iban_euro_desc,
                            maxLines: 5,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SpaceH16(),
          IBanItem(
            name: intl.iban_benificiary,
            text: name,
          ),
          IBanItem(
            name: intl.iban_iban,
            text: iban,
          ),
          IBanItem(
            name: intl.iban_bic,
            text: bic,
          ),
          const SpaceH20(),
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SInfoIcon(
                  color: colors.black,
                ),
                const SpaceW16(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 88,
                  child: Text(
                    intl.iban_terms,
                    style: sBodyText2Style,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ),
          const SpaceH42(),
        ],
      ),
    );
  }

}
