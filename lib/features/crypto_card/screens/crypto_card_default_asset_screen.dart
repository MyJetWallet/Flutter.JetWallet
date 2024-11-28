import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/crypto_card/store/create_crypto_card_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardDefaultAssetRoute')
class CryptoCardDefaultAssetScreen extends StatelessWidget {
  const CryptoCardDefaultAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = getIt.get<CreateCryptoCardStore>();

    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      child: Observer(
        builder: (context) {
          final asset = store.defaultAsset;

          return Stack(
            children: [
              CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
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
                                intl.crypto_card_account_title,
                                style: STStyles.header5,
                              ),
                              const SpaceH12(),
                              Text(
                                intl.crypto_card_account_description,
                                style: STStyles.subtitle2.copyWith(
                                  color: colors.gray10,
                                ),
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                        const SpaceH16(),
                        SuggestionButtonWidget(
                          subTitle: intl.crypto_card_account_crypto,
                          title: asset.description,
                          trailing: asset.volumeAssetBalance,
                          showArrow: false,
                          icon: NetworkIconWidget(
                            asset.iconUrl,
                          ),
                          onTap: () {},
                        ),
                        const SpaceH100(),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
                    ),
                    child: SButton.black(
                      text: intl.register_continue,
                      callback: () {
                        store.routCardIssueCostSheetScreen();
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
