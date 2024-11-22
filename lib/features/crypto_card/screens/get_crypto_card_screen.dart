import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/store/create_crypto_card_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'GetCryptoCardRoute')
class GetCryptoCardScreen extends StatelessWidget {
  const GetCryptoCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: const GlobalBasicAppBar(
        hasLeftIcon: false,
        hasRightIcon: false,
      ),
      child: Stack(
        children: [
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Image.asset(
                          cryptoCardPreview2,
                        ),
                      ),
                      Text(
                        intl.crypto_card_order_title,
                        maxLines: 3,
                        style: STStyles.header5,
                      ),
                      const SpaceH12(),
                      Text(
                        intl.crypto_card_order_description,
                        maxLines: 5,
                        style: STStyles.subtitle2.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                      const SpaceH120(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: SButton.black(
                text: intl.crypto_card_get_your_virtual_card_now,
                callback: getIt.get<CreateCryptoCardStore>().startCreatingFlow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
