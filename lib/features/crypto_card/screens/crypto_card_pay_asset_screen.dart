import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/crypto_card/store/create_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_pay_with_asset_bottom_sheet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardPayAssetRoute')
class CryptoCardPayAssetScreen extends StatelessWidget {
  const CryptoCardPayAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = getIt.get<CreateCryptoCardStore>();

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: store.loader,
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      child: Observer(
        builder: (context) {
          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: 172,
                      child: Image.asset(
                        cryptoCardPreviewSmall,
                      ),
                    ),
                    Text(
                      intl.crypto_card_pay_title,
                      style: STStyles.header6,
                    ),
                    const SpaceH4(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (store.price != null) ...[
                          Text(
                            store.price?.userPrice.toFormatSum(
                                  symbol: store.price?.assetSymbol,
                                ) ??
                                '',
                            style: STStyles.header5,
                          ),
                          const SpaceW4(),
                          if (store.price?.regularPrice != store.price?.userPrice)
                            Text(
                              store.price?.regularPrice.toFormatSum(
                                    symbol: store.price?.assetSymbol,
                                  ) ??
                                  '',
                              style: STStyles.subtitle2.copyWith(
                                color: SColorsLight().gray8,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ] else ...[
                          SSkeletonLoader(
                            height: 32,
                            width: 100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ],
                    ),
                    const SpaceH24(),
                    SPaddingH24(
                      child: Text(
                        intl.crypto_card_pay_description,
                        style: STStyles.subtitle2.copyWith(
                          color: colors.gray10,
                        ),
                        maxLines: 4,
                      ),
                    ),
                    const SpaceH32(),
                    Row(
                      children: [
                        SPaddingH24(
                          child: Text(
                            intl.crypto_card_pay_payment_method,
                            style: STStyles.subtitle1,
                          ),
                        ),
                      ],
                    ),
                    const SpaceH8(),
                    SuggestionButtonWidget(
                      subTitle: intl.crypto_card_pay_pay_with,
                      title: store.selectedAsset?.description,
                      trailing: store.selectedAsset?.volumeAssetBalance,
                      icon: store.selectedAsset != null
                          ? NetworkIconWidget(
                              store.selectedAsset?.iconUrl ?? '',
                            )
                          : Assets.svg.other.medium.crypto.simpleSvg(),
                      onTap: () {
                        showPayWithAssetBottomSheet(
                          context: context,
                          store: store,
                        );
                      },
                    ),
                    const SpaceH24(),
                    const Spacer(),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 16,
                          bottom: 16 + MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
                        ),
                        child: SButton.black(
                          text: intl.crypto_card_pay_continue,
                          callback: store.isPayValid
                              ? () {
                                  sRouter.push(const CryptoCardNameRoute());
                                }
                              : null,
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
