import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/public/simple_secondary_button_1.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../core/l10n/i10n.dart';
import '../../../utils/constants.dart';

class IBanEmpty extends StatelessObserverWidget {
  const IBanEmpty({
    super.key,
    required this.isLoading,
    required this.isAddress,
    required this.isKyc,
    this.onButtonTap,
  });

  final bool isLoading;
  final bool isAddress;
  final bool isKyc;
  final Function()? onButtonTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final mainText = isKyc
        ? intl.iban_not_verified
        : isLoading
            ? intl.iban_not_waiting
            : intl.iban_not_address;
    final secondaryText = isKyc
        ? intl.iban_not_verified_desc
        : isLoading
            ? intl.iban_not_waiting_desc
            : intl.iban_not_address_desc;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isLoading ? verifyingNowAsset : verifyYourProfileAsset,
              width: 80,
            ),
            const SpaceH24(),
            Text(
              mainText,
              style: sTextH5Style,
            ),
            const SpaceH8(),
            Row(
              children: [
                const SpaceW60(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 120,
                  child: Text(
                    secondaryText,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: sBodyText1Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
                const SpaceW60(),
              ],
            ),
          ],
        ),
        Column(
          children: [
            SPaddingH24(
              child: SSecondaryButton1(
                name: intl.iban_get_account,
                active: !isLoading || isKyc,
                onTap: () {
                  onButtonTap?.call();
                },
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ],
    );
  }
}
