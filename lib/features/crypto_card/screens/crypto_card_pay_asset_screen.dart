import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_pay_asset_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_pay_with_asset_bottom_sheet.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_price_widget.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardPayAssetRoute')
class CryptoCardPayAssetScreen extends StatelessWidget {
  const CryptoCardPayAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoCardPayAssetStore()..init(),
      child: const _CryptoCardPayAssetBody(),
    );
  }
}

class _CryptoCardPayAssetBody extends StatelessWidget {
  const _CryptoCardPayAssetBody();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = CryptoCardPayAssetStore.of(context);

    final discount = (((store.price?.regularPrice ?? Decimal.zero) - (store.price?.userPrice ?? Decimal.zero)) /
                (store.price?.regularPrice ?? Decimal.fromInt(1)))
            .toDecimal(scaleOnInfinitePrecision: 2) *
        Decimal.fromInt(100);

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
                    if (store.price != null)
                      CryptoCardPriceWidget(
                        userPrice: store.price?.userPrice ?? Decimal.zero,
                        regularPrice: store.price?.regularPrice ?? Decimal.zero,
                        assetSymbol: store.price?.assetSymbol ?? 'EUR',
                        discount: discount,
                      )
                    else
                      SSkeletonLoader(
                        height: 31,
                        width: 80,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    const SpaceH24(),
                    if (store.price != null)
                      SPaddingH24(
                        child: Text(
                          discount == Decimal.zero
                              ? intl.crypto_card_pay_description_0
                              : discount == Decimal.fromInt(100)
                                  ? intl.crypto_card_pay_description_100
                                  : intl.crypto_card_pay_description_50,
                          style: STStyles.body2Semibold.copyWith(
                            color: colors.gray10,
                          ),
                          maxLines: 4,
                        ),
                      )
                    else
                      SSkeletonLoader(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 48,
                        borderRadius: BorderRadius.circular(6),
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
                          store: store as CryptoCardPayAssetStore,
                        );
                      },
                      isDisabled: store.avaibleAssets.isEmpty,
                    ),
                    if (!store.isEnoughBalanceToPay && store.selectedAsset != null)
                      OneColumnCell(
                        icon: Assets.svg.small.warning,
                        text: intl.crypto_card_creat_insufficient_funds,
                        color: colors.red,
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
                          bottom: 16 + MediaQuery.of(context).padding.bottom <= 24 ? 24 : 16,
                        ),
                        child: SButton.black(
                          text: intl.crypto_card_pay_continue,
                          callback: store.isPayValid
                              ? () {
                                  store.onContinueTap();
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
