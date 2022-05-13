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
          Expanded(
            child: SPrimaryButton1(
              name: intl.buy,
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
                name: intl.receive,
                onTap: () {
                  if (kycState.withdrawalStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sAnalytics.depositCryptoView(currency.description);

                    navigatorPushReplacement(
                      context,
                      CryptoDeposit(
                        header: intl.receive,
                        currency: currency,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.withdrawalStatus,
                      kycVerified: kycState,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        sAnalytics.depositCryptoView(currency.description);

                        navigatorPushReplacement(
                          context,
                          CryptoDeposit(
                            header: intl.receive,
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
                name: intl.sell,
                onTap: () {
                  if (kycState.sellStatus ==
                      kycOperationStatus(KycStatus.allowed)) {
                    sAnalytics.sellView(
                      Source.assetScreen,
                      currency.description,
                    );
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
                        sAnalytics.sellView(
                          Source.assetScreen,
                          currency.description,
                        );
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
