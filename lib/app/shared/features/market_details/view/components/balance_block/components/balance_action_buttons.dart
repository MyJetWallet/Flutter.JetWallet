import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../helpers/are_balances_empty.dart';
import '../../../../../../helpers/is_buy_with_currency_available_for.dart';
import '../../../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../../../crypto_deposit/view/crypto_deposit.dart';
import '../../../../../currency_buy/view/curency_buy.dart';
import '../../../../../currency_sell/view/currency_sell.dart';
import '../../../../../kyc/model/kyc_operation_status_model.dart';
import '../../../../../kyc/notifier/kyc/kyc_notipod.dart';
import '../../../../helper/currency_from.dart';

class BalanceActionButtons extends HookWidget {
  const BalanceActionButtons({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final currencies = useProvider(currenciesPod);
    final currency = currencyFrom(
      currencies,
      marketItem.associateAsset,
    );
    final isBalanceEmpty = areBalancesEmpty(currencies);
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

    return SPaddingH24(
      child: Row(
        children: [
          if (isBuyWithCurrencyAvailableFor(currency.symbol, currencies))
            Expanded(
              child: SPrimaryButton1(
                name: intl.balanceActionButtons_buy,
                onTap: () {
                  if (kycState.depositStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sAnalytics.buyView(
                      Source.assetScreen,
                      currency.description,
                    );
                    navigatorPush(
                      context,
                      CurrencyBuy(
                        currency: currency,
                        fromCard: isBalanceEmpty,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      kycVerified: kycState,
                      isProgress: kycState.verificationInProgress,
                      navigatePop: true,
                      currentNavigate: () {
                        sAnalytics.buyView(
                          Source.assetScreen,
                          currency.description,
                        );
                        navigatorPush(
                          context,
                          CurrencyBuy(
                            currency: currency,
                            fromCard: isBalanceEmpty,
                          ),
                        );
                      },
                    );
                  }
                },
                active: true,
              ),
            ),
          if (marketItem.isBalanceEmpty) ...[
            const SpaceW11(),
            Expanded(
              child: SSecondaryButton1(
                name: intl.balanceActionButtons_receive,
                onTap: () {
                  sAnalytics.receiveClick(source: 'Market -> Asset -> Receive');
                  if (kycState.withdrawalStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sAnalytics.receiveAssetView(asset: currency.description);
                    navigatorPushReplacement(
                      context,
                      CryptoDeposit(
                        header: intl.balanceActionButtons_receive,
                        currency: currency,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.withdrawalStatus,
                      kycVerified: kycState,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        sAnalytics.receiveAssetView(
                          asset: currency.description,
                        );
                        navigatorPushReplacement(
                          context,
                          CryptoDeposit(
                            header: intl.balanceActionButtons_receive,
                            currency: currency,
                          ),
                        );
                      },
                    );
                  }
                },
                active: true,
              ),
            ),
          ],
          if (!marketItem.isBalanceEmpty) ...[
            const SpaceW11(),
            Expanded(
              child: SSecondaryButton1(
                name: intl.balanceActionButtons_sell,
                onTap: () {
                  if (kycState.sellStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    navigatorPush(
                      context,
                      CurrencySell(
                        currency: currency,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      kycVerified: kycState,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        navigatorPush(
                          context,
                          CurrencySell(
                            currency: currency,
                          ),
                        );
                      },
                    );
                  }
                },
                active: true,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
