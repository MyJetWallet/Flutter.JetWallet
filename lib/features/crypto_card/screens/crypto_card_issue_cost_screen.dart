import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardIssueCostRoute')
class CryptoCardIssueCostScreen extends StatelessWidget {
  const CryptoCardIssueCostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      color: colors.gray2,
      child: Column(
        children: [
          ColoredBox(
            color: colors.white,
            child: Column(
              children: [
                Image.asset(
                  cryptoCardPreview,
                ),
                SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card issue',
                        style: STStyles.header5,
                      ),
                      const SpaceH12(),
                      Text(
                        'Awesome! You are one step closer to the release of Simple Crypto Card',
                        style: STStyles.subtitle2.copyWith(
                          color: colors.gray10,
                        ),
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                SCopyable(
                  label: 'Card issue cost',
                  value: '4 EUR',
                  onIconTap: () {},
                  icon: const SizedBox(),
                ),
                const SDivider(),
              ],
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: SButton.black(
              text: 'Pay',
              callback: () {},
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 16 + MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
              ),
              child: Text(
                'The issue of the card costs 4 EUR. Its maintenance is completely free, and the commission for calculations is 0%. The validity period of the Simple card is 5 years.',
                style: STStyles.captionMedium.copyWith(
                  color: colors.gray10,
                ),
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
