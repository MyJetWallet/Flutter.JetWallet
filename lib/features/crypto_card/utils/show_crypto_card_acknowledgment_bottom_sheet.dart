import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<void> showCryptoCardAcknowledgmentBottomSheet(BuildContext context) async {
  await showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.crypto_card_acknowledgment,
    ),
    children: [
      const _AcknowledgmentBody(),
    ],
  );
}

class _AcknowledgmentBody extends StatefulWidget {
  const _AcknowledgmentBody();

  @override
  State<_AcknowledgmentBody> createState() => _AcknowledgmentBodyState();
}

class _AcknowledgmentBodyState extends State<_AcknowledgmentBody> {
  bool isAgreed = false;

  void toggleChecker() {
    setState(() {
      isAgreed = !isAgreed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SPaddingH24(
          child: Text(
            intl.crypto_card_description,
            style: STStyles.body1Semibold.copyWith(
              color: SColorsLight().gray10,
            ),
            maxLines: 5,
          ),
        ),
        SPaddingH24(
          child: SPolicyCheckbox(
            height: 65,
            firstText: intl.buy_confirmation_privacy_checkbox_1,
            userAgreementText: intl.buy_confirmation_privacy_checkbox_2,
            betweenText: ', ',
            privacyPolicyText: intl.buy_confirmation_privacy_checkbox_3,
            secondText: '',
            activeText: '',
            thirdText: '',
            activeText2: '',
            onCheckboxTap: toggleChecker,
            onUserAgreementTap: () {
              launchURL(context, userAgreementLink);
            },
            onPrivacyPolicyTap: () {
              launchURL(context, privacyPolicyLink);
            },
            onActiveTextTap: () {},
            onActiveText2Tap: () {},
            isChecked: isAgreed,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 32,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
            ),
            child: SButton.black(
              text: intl.register_continue,
              callback: isAgreed
                  ? () {
                      sRouter.popAndPush(const CryptoCardDefaultAssetRoute());
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
