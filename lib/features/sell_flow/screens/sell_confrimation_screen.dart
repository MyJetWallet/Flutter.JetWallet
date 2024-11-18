import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/sell_flow/store/sell_confirmation_store.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
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
    this.account,
    this.simpleCard,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final SimpleBankingAccount? account;
  final CardDataModel? simpleCard;

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
          toAsset: account?.currency ?? simpleCard?.currency ?? '',
          toAmount: toAmount,
          newAccountId: account?.accountId ?? simpleCard?.cardId ?? '',
          newAccountLabel: account?.label ?? simpleCard?.label ?? '',
        ),
      builder: (context, child) => _SellConfirmationScreenBody(
        account: account,
        simpleCard: simpleCard,
      ),
      dispose: (context, value) {
        value.cancelTimer();
        value.cancelAllRequest();
      },
    );
  }
}

class _SellConfirmationScreenBody extends StatelessObserverWidget {
  const _SellConfirmationScreenBody({
    this.account,
    this.simpleCard,
  });

  final SimpleBankingAccount? account;
  final CardDataModel? simpleCard;

  @override
  Widget build(BuildContext context) {
    final store = SellConfirmationStore.of(context);

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              onSkip: () {
                store.skipProcessing();
              },
            )
          : null,
      header: GlobalBasicAppBar(
        title: intl.buy_confirmation_title,
        subtitle: intl.sell_confirmation_subtitle,
        onLeftIconTap: () {
          sAnalytics.tapOnTheBackFromSellConfirmationButton();
          sRouter.maybePop();
        },
        hasRightIcon: false,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  STransaction(
                    isLoading: !store.isDataLoaded,
                    fromAssetIconUrl: store.payCurrency.iconUrl,
                    fromAssetDescription: store.payCurrency.symbol,
                    fromAssetValue: (store.paymentAmount ?? Decimal.zero).toFormatCount(
                      symbol: store.payCurrency.symbol,
                      accuracy: store.payCurrency.accuracy,
                    ),
                    toAssetIconUrl: store.buyCurrency.iconUrl,
                    toAssetDescription: store.buyCurrency.description,
                    toAssetValue: (store.buyAmount ?? Decimal.zero).toFormatCount(
                      accuracy: store.buyCurrency.accuracy,
                      symbol: store.buyCurrency.symbol,
                    ),
                  ),
                  SellConfirmationInfoGrid(
                    paymentFee: store.depositFeeCurrency.type == AssetType.crypto
                        ? (store.depositFeeAmount ?? Decimal.zero).toFormatCount(
                            accuracy: store.depositFeeCurrency.accuracy,
                            symbol: store.depositFeeCurrency.symbol,
                          )
                        : (store.depositFeeAmount ?? Decimal.zero).toFormatSum(
                            accuracy: store.depositFeeCurrency.accuracy,
                            symbol: store.depositFeeCurrency.symbol,
                          ),
                    ourFee: store.tradeFeeCurreny.type == AssetType.crypto
                        ? (store.tradeFeeAmount ?? Decimal.zero).toFormatCount(
                            accuracy: store.tradeFeeCurreny.accuracy,
                            symbol: store.tradeFeeCurreny.symbol,
                          )
                        : (store.tradeFeeAmount ?? Decimal.zero).toFormatSum(
                            accuracy: store.tradeFeeCurreny.accuracy,
                            symbol: store.tradeFeeCurreny.symbol,
                          ),
                    totalValue: (store.paymentAmount ?? Decimal.zero).toFormatCount(
                      symbol: store.payCurrency.symbol,
                      accuracy: store.payCurrency.accuracy,
                    ),
                    paymentCurrency: store.payCurrency,
                    asset: store.buyCurrency,
                    account: account,
                    simpleCard: simpleCard,
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
                    child: SButton.blue(
                      text: intl.previewBuyWithAsset_confirm,
                      callback: !store.loader.loading && store.getCheckbox
                          ? () {
                              store.createPayment();
                            }
                          : null,
                    ),
                  ),
                  Text(
                    simpleCompanyName,
                    style: STStyles.captionMedium.copyWith(
                      color: SColorsLight().gray10,
                    ),
                  ),
                  Text(
                    simpleCompanyAddress,
                    style: STStyles.captionMedium.copyWith(
                      color: SColorsLight().gray10,
                    ),
                    maxLines: 2,
                  ),
                  const SpaceH40(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
