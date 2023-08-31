import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/buy_flow/store/buy_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/confirmation_widgets/confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage()
class BuyConfirmationScreen extends StatelessWidget {
  const BuyConfirmationScreen({
    super.key,
    required this.asset,
    required this.paymentCurrency,
    required this.amount,
    this.method,
    this.card,
    this.cardNumber,
    this.cardId,
    this.preset,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final BuyMethodDto? method;

  final CircleCard? card;

  final String? cardNumber;
  final String? cardId;

  final String amount;
  final String? preset;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyConfirmationStore>(
      create: (context) => BuyConfirmationStore()
        ..loadPreview(
          amount,
          asset.symbol,
          paymentCurrency.symbol,
          method,
          card,
          preset,
        ),
      builder: (context, child) => _BuyConfirmationScreenBody(
        asset: asset,
        paymentCurrency: paymentCurrency,
        amount: amount,
        method: method,
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
    this.method,
    this.card,
  });

  final CurrencyModel asset;
  final CurrencyModel paymentCurrency;

  final BuyMethodDto? method;
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
                Text(
                  store.category == PaymentMethodCategory.cards
                      ? intl.previewBuyWithCircle_youWillGet
                      : intl.previewBuyWithCircle_youWillGetApproximately,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: sKit.colors.grey1,
                  ),
                ),
                if (store.isDataLoaded) ...[
                  Text(
                    volumeFormat(
                      prefix: asset.prefixSymbol,
                      decimal: store.buyAmount ?? Decimal.zero,
                      accuracy: asset.accuracy,
                      symbol: asset.symbol,
                    ),
                    textAlign: TextAlign.center,
                    style: sTextH4Style.copyWith(
                      color: sKit.colors.blue,
                    ),
                  ),
                ] else ...[
                  const Baseline(
                    baseline: 19.0,
                    baselineType: TextBaseline.alphabetic,
                    child: SSkeletonTextLoader(
                      height: 16,
                      width: 130,
                    ),
                  ),
                ],
                const SizedBox(height: 25),
                ConfirmationInfoGrid(
                  paymentFee: volumeFormat(
                    prefix: store.depositFeeCurrency.prefixSymbol,
                    decimal: store.depositFeeAmount ?? Decimal.zero,
                    accuracy: store.depositFeeCurrency.accuracy,
                    symbol: store.depositFeeCurrency.symbol,
                  ),
                  ourFee: volumeFormat(
                    prefix: store.tradeFeeCurreny.prefixSymbol,
                    decimal: store.tradeFeeAmount ?? Decimal.zero,
                    accuracy: store.tradeFeeCurreny.accuracy,
                    symbol: store.tradeFeeCurreny.symbol,
                  ),
                  totalValue: volumeFormat(
                    prefix: paymentCurrency.prefixSymbol,
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
                      store.category == PaymentMethodCategory.cards
                          ? store.setIsBankTermsChecked()
                          : store.setIsLocalTermsChecked();
                    },
                    onUserAgreementTap: () {
                      launchURL(context, userAgreementLink);
                    },
                    onPrivacyPolicyTap: () {
                      launchURL(context, privacyPolicyLink);
                    },
                    onActiveTextTap: () {},
                    onActiveText2Tap: () {},
                    isChecked: store.category == PaymentMethodCategory.cards
                        ? store.isBankTermsChecked
                        : store.isLocalTermsChecked,
                  ),
                ] else ...[
                  SPolicy(
                    isChecked: store.isP2PTermsChecked,
                    onCheckboxTap: () {
                      store.seIsP2PTermsChecked();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpaceH22(),
                        Text(
                          intl.buy_confirmation_privacy_p2p_checkbox_1,
                          maxLines: 3,
                          style: sBodyText2Style.copyWith(
                            fontFamily: 'Gilroy',
                            height: 1.42,
                            color: sKit.colors.black,
                          ),
                        ),
                        const SpaceH8(),
                        RichText(
                          text: TextSpan(
                            text:
                                intl.buy_confirmation_privacy_p2p_checkbox_1_5,
                            style: sBodyText2Style.copyWith(
                              fontFamily: 'Gilroy',
                              height: 1.42,
                              color: sKit.colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: intl
                                    .buy_confirmation_privacy_p2p_checkbox_2,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchURL(context, p2pTerms);
                                  },
                                style: TextStyle(
                                  color: sKit.colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SpaceH8(),
                        Text(
                          intl.buy_confirmation_privacy_p2p_checkbox_3,
                          maxLines: 3,
                          style: sBodyText2Style.copyWith(
                            fontFamily: 'Gilroy',
                            height: 1.42,
                            color: sKit.colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            sShowAlertPopup(
                              context,
                              primaryText: '',
                              secondaryText:
                                  intl.buy_confirmation_privacy_p2p_popup,
                              primaryButtonName: intl.global_send_got_it,
                              image: Image.asset(
                                infoLightAsset,
                                height: 80,
                                width: 80,
                                package: 'simple_kit',
                              ),
                              onPrimaryButtonTap: () =>
                                  {Navigator.pop(context)},
                              cancelText: intl.profileDetails_cancel,
                              onCancelButtonTap: () => {Navigator.pop(context)},
                            );
                          },
                          child: Text(
                            intl.buy_confirmation_privacy_p2p_heckbox_4,
                            maxLines: 3,
                            style: sBodyText2Style.copyWith(
                              fontFamily: 'Gilroy',
                              height: 1.42,
                              color: sKit.colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
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
