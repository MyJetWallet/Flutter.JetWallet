import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/buy_flow/store/sell_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/sell_confirmation_widgets/sell_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

@RoutePage(name: 'SellConfirmationRoute')
class SellConfirmationScreen extends StatelessWidget {
  const SellConfirmationScreen({
    super.key,
    required this.asset,
    required this.paymentCurrency,
    required this.isFromFixed,
    required this.fromAmount,
    required this.toAmount,
    required this.account,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final SimpleBankingAccount account;

  final bool isFromFixed;
  final Decimal fromAmount;
  final Decimal toAmount;

  @override
  Widget build(BuildContext context) {
    return Provider<SellConfirmationStore>(
      create: (context) => SellConfirmationStore()
        ..loadPreview(
          newIsFromFixed: isFromFixed,
          fromAmount: fromAmount,
          fromAsset: asset.symbol,
          toAsset: account.currency ?? '',
          toAmount: toAmount,
          newAccountId: account.accountId ?? '',
        ),
      builder: (context, child) => _BuyConfirmationScreenBody(
        paymentCurrency: paymentCurrency,
        account: account,
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
    required this.paymentCurrency,
    required this.account,
  });

  final CurrencyModel paymentCurrency;
  final SimpleBankingAccount account;

  @override
  Widget build(BuildContext context) {
    final store = SellConfirmationStore.of(context);
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: store.wasAction,
              primaryText: intl.buy_confirmation_local_p2p_processing_title,
              onSkip: () {
                store.skipProcessing();

                navigateToRouter();
              },
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.sell_confirmation_subtitle,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
        onBackButtonTap: () => sRouter.pop(),
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
                SellConfirmationInfoGrid(
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
                    decimal: store.paymentAmount ?? Decimal.zero,
                  ),
                  paymentCurrency: store.payCurrency,
                  asset: store.buyCurrency,
                  account: account,
                ),
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
