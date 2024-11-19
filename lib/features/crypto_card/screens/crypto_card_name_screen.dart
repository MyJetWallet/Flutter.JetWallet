import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardNameRoute')
class CryptoCardNameScreen extends StatelessWidget {
  const CryptoCardNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        rightIcon: Text(
          intl.crypto_card_name_skip,
          style: STStyles.button.copyWith(
            color: SColorsLight().blue,
          ),
        ),
        onLeftIconTap: () {
          sRouter.popUntilRoot();
        },
        onRightIconTap: () {
          sRouter.popUntilRoot();
        },
      ),
      child: Column(
        children: [
          SizedBox(
            height: 172,
            child: Image.asset(
              cryptoCardPreviewSmall,
            ),
          ),
          SPaddingH24(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.crypto_card_name_your_card,
                  style: STStyles.header5,
                ),
              ],
            ),
          ),
          const SpaceH32(),
          SInput(
            label: intl.crypto_card_name_card_name,
            hasCloseIcon: true,
            initialValue: 'Crypto card',
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 16 + MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
              ),
              child: SButton.black(
                text: intl.crypto_card_name_create_card,
                callback: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
