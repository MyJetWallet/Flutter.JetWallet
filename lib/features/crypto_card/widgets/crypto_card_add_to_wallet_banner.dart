import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_wallet_redirecting_popup.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CryptoCardAddToWalletBanner extends StatelessWidget {
  const CryptoCardAddToWalletBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final store = Provider.of<MainCryptoCardStore>(context);
        final showAddToWalletBanner = store.showAddToWalletBanner;

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: showAddToWalletBanner ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: _BannerWidget(
            onCloseBanner: () {
              store.closeBanner();
            },
          ),
          secondChild: Container(),
        );
      },
    );
  }
}

class _BannerWidget extends StatelessWidget {
  const _BannerWidget({this.onCloseBanner});

  final void Function()? onCloseBanner;

  @override
  Widget build(BuildContext context) {
    Widget icon = Container();
    var title = '';
    var description = '';
    if (Platform.isAndroid) {
      icon = Assets.svg.card.googleWallet.simpleSvg(
        height: 20.0,
        width: 20.0,
      );
      title = intl.crypto_card_add_to_google_wallet_title;
      description = intl.crypto_card_add_to_google_wallet_description;
    } else {
      icon = Assets.svg.card.appleWallet.simpleSvg(
        height: 20.0,
        width: 20.0,
      );
      title = intl.crypto_card_add_to_apple_wallet_title;
      description = intl.crypto_card_add_to_apple_wallet_description;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SafeGesture(
        onTap: () {
          sAnalytics.tapAddToWallet(
            walletType: Platform.isAndroid ? 'Google Wallet' : 'Apple Wallet',
          );
          showWalletRedirectingPopup(context);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: SColorsLight().gray2,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SafeGesture(
                  onTap: () {
                    sAnalytics.tapCloseAddToWalletBanner(
                      walletType: Platform.isAndroid ? 'Google Wallet' : 'Apple Wallet',
                    );
                    onCloseBanner?.call();
                  },
                  child: Assets.svg.medium.close.simpleSvg(
                    height: 20.0,
                    width: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  top: 4.0,
                  bottom: 4.0,
                  right: 36.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        icon,
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          title,
                          style: STStyles.subtitle2.copyWith(
                            color: SColorsLight().black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      description,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: STStyles.body2Medium.copyWith(
                        color: SColorsLight().gray10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
