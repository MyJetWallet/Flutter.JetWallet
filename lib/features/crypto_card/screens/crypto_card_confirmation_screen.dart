import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/price_crypto_card_response_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'CryptoCardConfirmationRoute')
class CryptoCardConfirmationScreen extends StatelessWidget {
  const CryptoCardConfirmationScreen({super.key, required this.fromAssetSymbol, required this.discount});

  final String fromAssetSymbol;
  final PriceCryptoCardResponseModel discount;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoCardConfirmationStore(
        fromAssetSymbol: fromAssetSymbol,
        discount: discount,
      ),
      child: const _ConfirmationBody(),
    );
  }
}

class _ConfirmationBody extends StatelessWidget {
  const _ConfirmationBody();

  @override
  Widget build(BuildContext context) {
    final store = CryptoCardConfirmationStore.of(context);
    return VisibilityDetector(
      key: const Key('CryptoCardConfirmationScreen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'CryptoCardConfirmationScreen',
                event: () {
                  sAnalytics.viewOrderSummary(
                    paymentAsset: store.fromAssetSymbol,
                    paymentAmountInCrypto: store.fromAmount.toString(),
                  );
                },
              );
        }
      },
      child: Observer(
        builder: (context) {
          return SPageFrame(
            loaderText: intl.loader_please_wait,
            loading: store.loader,
            customLoader: WaitingScreen(
              secondaryText: '',
              onSkip: () {},
              isCanClouse: false,
            ),
            header: GlobalBasicAppBar(
              hasRightIcon: false,
              title: intl.crypto_card_confirmation_order_summary,
              subtitle: intl.crypto_card_confirmation_card_issue,
            ),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      SPaddingH24(
                        child: STransaction(
                          isLoading: false,
                          fromAssetIconUrl: store.fromAsset.iconUrl,
                          fromAssetDescription: store.fromAsset.description,
                          fromAssetValue: store.fromAmount.toFormatCount(
                            symbol: store.fromAssetSymbol,
                            accuracy: store.fromAsset.accuracy,
                          ),
                          fromAssetBaseAmount: store.toAmount.toFormatSum(
                            symbol: store.toAssetSymbol,
                            accuracy: store.toAsset.accuracy,
                          ),
                          hasSecondAsset: false,
                        ),
                      ),
                      const SDivider(
                        withHorizontalPadding: true,
                      ),
                      const SpaceH8(),
                      TwoColumnCell(
                        label: intl.crypto_card_confirmation_pay_with,
                        value: store.fromAsset.description,
                        leftValueIcon: NetworkIconWidget(
                          store.fromAsset.iconUrl,
                        ),
                      ),
                      TwoColumnCell(
                        label: intl.crypto_card_confirmation_card_issue_cost,
                        value: store.discount.regularPrice.toFormatCount(
                          symbol: store.toAsset.symbol,
                          accuracy: store.toAsset.accuracy,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return store.discount.userDiscount != Decimal.zero
                              ? TwoColumnCell(
                                  label: intl.crypto_card_confirmation_discount(
                                    store.discount.userDiscount.toFormatPercentCount(),
                                  ),
                                  value: '-${((store.discount.userDiscount / Decimal.fromInt(100)).toDecimal(
                                        scaleOnInfinitePrecision: store.toAsset.accuracy,
                                      ) * store.discount.regularPrice).toFormatCount(
                                    symbol: store.toAsset.symbol,
                                    accuracy: store.toAsset.accuracy,
                                  )}',
                                )
                              : const SizedBox();
                        },
                      ),
                      TwoColumnCell(
                        label: intl.crypto_card_confirmation_price,
                        value:
                            '${Decimal.one.toFormatCount(symbol: store.fromAssetSymbol)} = ${store.price.toFormatCount(symbol: store.toAssetSymbol)}',
                      ),
                      const SpaceH16(),
                      const SDivider(
                        withHorizontalPadding: true,
                      ),
                      SPaddingH24(
                        child: SPolicyCheckbox(
                          height: 65,
                          firstText: intl.buy_confirmation_privacy_checkbox_1,
                          userAgreementText: intl.buy_confirmation_privacy_checkbox_2,
                          betweenText: ', ',
                          privacyPolicyText: intl.buy_confirmation_privacy_checkbox_3,
                          secondText: '',
                          activeText: '',
                          thirdText: '',
                          activeText2: '',
                          onCheckboxTap: store.toggleCheckBox,
                          onUserAgreementTap: () {
                            launchURL(context, userAgreementLink);
                          },
                          onPrivacyPolicyTap: () {
                            launchURL(context, privacyPolicyLink);
                          },
                          onActiveTextTap: () {},
                          onActiveText2Tap: () {},
                          isChecked: store.isCheckBoxSelected,
                        ),
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
                            callback: store.isContinueAvaible
                                ? () {
                                    sAnalytics.tapConfirmPayment(
                                      paymentAsset: store.fromAssetSymbol,
                                      paymentAmountInCrypto: store.fromAmount.toString(),
                                    );
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
            ),
          );
        },
      ),
    );
  }
}