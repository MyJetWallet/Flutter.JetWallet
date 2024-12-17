import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/store/create_crypto_card_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_safe_button_padding.dart';

@RoutePage(name: 'CryptoCardIssueCostRoute')
class CryptoCardIssueCostScreen extends StatelessWidget {
  const CryptoCardIssueCostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = getIt.get<CreateCryptoCardStore>();

    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      color: colors.gray2,
      child: Observer(
        builder: (context) {
          final amoumt = store.price?.userPrice.toFormatCount(
                symbol: store.price?.assetSymbol ?? 'EUR',
              ) ??
              '';

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
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
                                  intl.crypto_card_card_issue,
                                  style: STStyles.header5,
                                ),
                                const SpaceH12(),
                                Text(
                                  intl.crypto_card_card_issue_awesome,
                                  style: STStyles.subtitle2.copyWith(
                                    color: colors.gray10,
                                  ),
                                  maxLines: 4,
                                ),
                              ],
                            ),
                          ),
                          SCopyable(
                            label: intl.crypto_card_card_issue_cost,
                            value: amoumt,
                            onIconTap: () {},
                            icon: const SizedBox(),
                          ),
                          const SDivider(),
                        ],
                      ),
                    ),
                    const SpaceH24(),
                    const Spacer(),
                    SPaddingH24(
                      child: SButton.black(
                        text: intl.crypto_card_card_issue_pay,
                        callback: () {
                          sRouter.push(const CryptoCardNameRoute());
                        },
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: SSafeButtonPadding(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 16,
                            bottom: 8, // отступ кнопки (8)
                          ),
                          child: Text(
                            intl.crypto_card_card_issue_footer(amoumt),
                            style: STStyles.captionMedium.copyWith(
                              color: colors.gray10,
                            ),
                            maxLines: 5,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
