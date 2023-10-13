import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/buy_flow/store/buy_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/confirmation_widgets/confirmation_info_grid.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/confirmation_widgets/what_to_what_widget.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage()
class BuyConfirmationScreen extends StatelessWidget {
  const BuyConfirmationScreen({
    super.key,
    required this.asset,
    required this.paymentCurrency,
    required this.amount,
    this.card,
    this.account,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final CircleCard? card;
  final SimpleBankingAccount? account;

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyConfirmationStore>(
      create: (context) => BuyConfirmationStore()
        ..loadPreview(
          pAmount: amount,
          bAsset: asset.symbol,
          inputCard: card,
          inputAccount: account,
        ),
      builder: (context, child) => _BuyConfirmationScreenBody(
        asset: asset,
        paymentCurrency: paymentCurrency,
        amount: amount,
        card: card,
      ),
      dispose: (context, value) {
        value.cancelTimer();
        value.cancelAllRequest();
      },
    );
  }
}

class _BuyConfirmationScreenBody extends StatelessObserverWidget {
  const _BuyConfirmationScreenBody({
    required this.asset,
    required this.paymentCurrency,
    required this.amount,
    this.card,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final CircleCard? card;

  final String amount;

  @override
  Widget build(BuildContext context) {
    final store = BuyConfirmationStore.of(context);

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: store.wasAction,
              primaryText: intl.buy_confirmation_local_p2p_processing_title,
              secondaryText: store.getProcessingText,
              onSkip: () {
                store.skipProcessing();

                navigateToRouter();
              },
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        onBackButtonTap: () => sRouter.pop(),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                WhatToWhatWidget(
                  fromAssetIconUrl: paymentCurrency.iconUrl,
                  fromAssetDescription: paymentCurrency.symbol,
                  fromAssetValue: volumeFormat(
                    symbol: paymentCurrency.symbol,
                    accuracy: paymentCurrency.accuracy,
                    decimal: Decimal.parse(amount),
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
                    symbol: paymentCurrency.symbol,
                    accuracy: paymentCurrency.accuracy,
                    decimal: Decimal.parse(amount),
                  ),
                  paymentCurrency: paymentCurrency,
                  asset: asset,
                ),
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
                    },
                    onPrivacyPolicyTap: () {
                      launchURL(context, privacyPolicyLink);
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
