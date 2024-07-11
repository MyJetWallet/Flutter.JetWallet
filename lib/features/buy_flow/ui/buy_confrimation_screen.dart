import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/buy_flow/store/buy_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/confirmation_widgets/confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage(name: 'BuyConfirmationRoute')
class BuyConfirmationScreen extends StatelessWidget {
  const BuyConfirmationScreen({
    super.key,
    required this.asset,
    required this.paymentCurrency,
    required this.isFromFixed,
    this.fromAmount,
    this.toAmount,
    this.card,
    this.account,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final CircleCard? card;
  final SimpleBankingAccount? account;

  final bool isFromFixed;
  final String? fromAmount;
  final String? toAmount;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyConfirmationStore>(
      create: (context) => BuyConfirmationStore()
        ..loadPreview(
          newIsFromFixed: isFromFixed,
          pAmount: fromAmount ?? '0',
          bAsset: asset.symbol,
          inputCard: card,
          inputAccount: account,
          bAmount: toAmount,
        ),
      builder: (context, child) => const _BuyConfirmationScreenBody(),
      dispose: (context, value) {
        value.cancelTimer();
        value.cancelAllRequest();
      },
    );
  }
}

class _BuyConfirmationScreenBody extends StatelessObserverWidget {
  const _BuyConfirmationScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = BuyConfirmationStore.of(context);
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              secondaryText: store.getProcessingText,
              isLoading: true,
              onSkip: () {
                store.skipProcessing();
              },
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.buy_confirmation_subtitle,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
        onBackButtonTap: () => sRouter.maybePop(),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                WhatToWhatConvertWidget(
                  isLoading: !store.isDataLoaded,
                  fromAssetIconUrl: store.payCurrency.iconUrl,
                  fromAssetDescription: store.payCurrency.symbol,
                  fromAssetValue: volumeFormat(
                    symbol: store.payCurrency.symbol,
                    accuracy: store.payCurrency.accuracy,
                    decimal: store.paymentAmount ?? Decimal.zero,
                  ),
                  toAssetIconUrl: store.buyCurrency.iconUrl,
                  toAssetDescription: store.buyCurrency.description,
                  toAssetValue: volumeFormat(
                    decimal: store.buyAmount ?? Decimal.zero,
                    accuracy: store.buyCurrency.accuracy,
                    symbol: store.buyCurrency.symbol,
                  ),
                ),
                ConfirmationInfoGrid(
                  paymentFee: volumeFormat(
                    decimal: store.depositFeeAmount ?? Decimal.zero,
                    accuracy: store.depositFeeCurrency.accuracy,
                    symbol: store.depositFeeCurrency.symbol,
                  ),
                  ourFee: volumeFormat(
                    decimal: store.tradeFeeAmount ?? Decimal.zero,
                    accuracy: store.tradeFeeCurreny.accuracy,
                    symbol: store.tradeFeeCurreny.symbol,
                  ),
                  totalValue: volumeFormat(
                    symbol: store.payCurrency.symbol,
                    accuracy: store.payCurrency.accuracy,
                    decimal: store.paymentAmount ?? Decimal.zero,
                  ),
                  paymentCurrency: store.payCurrency,
                  asset: store.buyCurrency,
                ),
                if (!(store.account?.isClearjuctionAccount ?? false) &&
                    store.category == PaymentMethodCategory.account) ...[
                  const SpaceH19(),
                  Builder(
                    builder: (context) {
                      final text =
                          '''${intl.buy_confirm_with_unlimit_1_part} ${volumeFormat(symbol: store.payCurrency.symbol, accuracy: store.payCurrency.accuracy, decimal: store.paymentAmount ?? Decimal.zero)} ${intl.buy_confirm_with_unlimit_2_part} ${splitIban(store.ibanBuyDestination.trim())} ${intl.buy_confirm_with_unlimit_3_part} ${store.ibanBuyBeneficiary}''';

                      return Text(
                        text,
                        style: sCaptionTextStyle.copyWith(
                          color: SColorsLight().gray8,
                        ),
                        maxLines: 20,
                      );
                    },
                  ),
                ],
                const SpaceH19(),
                const SDivider(),
                if (store.category != PaymentMethodCategory.p2p) ...[
                  SPolicyCheckbox(
                    height: 65,
                    firstText: intl.buy_confirmation_privacy_checkbox_1,
                    userAgreementText: intl.buy_confirmation_privacy_checkbox_2,
                    betweenText: ', ',
                    privacyPolicyText: intl.buy_confirmation_privacy_checkbox_3,
                    secondText: '',
                    activeText: '',
                    thirdText: '',
                    activeText2: '',
                    onCheckboxTap: () {
                      store.setIsBankTermsChecked();
                    },
                    onUserAgreementTap: () {
                      launchURL(context, userAgreementLink);
                      sAnalytics.tapOnTheButtonTermsAndConditionsOnBuyOrderSummary(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.buyAsset ?? '',
                        sourceBuyAmount: store.paymentAmount.toString(),
                        destinationBuyAmount: store.buyAmount.toString(),
                      );
                    },
                    onPrivacyPolicyTap: () {
                      launchURL(context, privacyPolicyLink);
                      sAnalytics.tapOnTheButtonPrivacyPolicyOnBuyOrderSummary(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.buyAsset ?? '',
                        sourceBuyAmount: store.paymentAmount.toString(),
                        destinationBuyAmount: store.buyAmount.toString(),
                      );
                    },
                    onActiveTextTap: () {},
                    onActiveText2Tap: () {},
                    isChecked: store.isBankTermsChecked,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SPrimaryButton2(
                    active: !store.loader.loading && store.getCheckbox,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      sAnalytics.tapOnTheButtonConfirmOnBuyOrderSummary(
                        pmType: store.pmType,
                        buyPM: store.buyPM,
                        sourceCurrency: 'EUR',
                        destinationWallet: store.buyAsset ?? '',
                        sourceBuyAmount: store.paymentAmount.toString(),
                        destinationBuyAmount: store.buyAmount.toString(),
                      );
                      store.createPayment();
                    },
                  ),
                ),
                Text(
                  simpleCompanyName,
                  style: sCaptionTextStyle.copyWith(
                    color: sKit.colors.grey1,
                  ),
                ),
                Text(
                  simpleCompanyAddress,
                  style: sCaptionTextStyle.copyWith(
                    color: sKit.colors.grey1,
                  ),
                  maxLines: 2,
                ),
                const SpaceH40(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
