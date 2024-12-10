import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CryptoCardAmountWidget extends StatelessWidget {
  const CryptoCardAmountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final store = Provider.of<MainCryptoCardStore>(context);

    return Observer(
      builder: (context) {
        final assets = store.linkedAssets;
        return Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 16.0,
          ),
          child: Column(
            children: [
              Text(
                store.cardBalance.toFormatSum(
                  accuracy: store.cardBaseAsset.accuracy,
                  symbol: store.cardBaseAsset.symbol,
                ),
                style: STStyles.header3,
              ),
              const SizedBox(
                height: 4.0,
              ),
              SafeGesture(
                onTap: () {
                  sAnalytics.tapLinkedAssets();
                  sRouter.push(const CryptoCardLinkedAssetsRoute());
                },
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: assets.length > 1 ? (16 * assets.length + 4).toDouble() : 20,
                      height: 20,
                      child: Stack(
                        children: [
                          for (var i = 0; i < assets.length; i++)
                            Positioned(
                              right: i == 0 ? 0 : i * 16,
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.5,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      color: colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: NetworkIconWidget(
                                  assets.reversed.toList()[i].iconUrl,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      intl.crypto_card_asset_linked(store.linkedAssets.length),
                      style: STStyles.body2Semibold,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Assets.svg.medium.shevronRight.simpleSvg(
                      height: 16.0,
                      width: 16.0,
                      color: colors.gray8,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
