import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/helpers/is_buy_with_currency_available_for.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helper/currency_from.dart';

class BalanceActionButtons extends StatelessObserverWidget {
  const BalanceActionButtons({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.getCurrencies;
    final currency = currencyFrom(
      currencies,
      marketItem.associateAsset,
    );
    final isBalanceEmpty = areBalancesEmpty(currencies);
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

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

                    sRouter.push(
                      CurrencyBuyRouter(
                        currency: currency,
                        fromCard: isBalanceEmpty,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.depositStatus,
                      isProgress: kycState.verificationInProgress,
                      navigatePop: true,
                      currentNavigate: () {
                        sAnalytics.buyView(
                          Source.assetScreen,
                          currency.description,
                        );

                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: currency,
                            fromCard: isBalanceEmpty,
                          ),
                        );
                      },
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
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
                    sRouter.navigate(
                      CryptoDepositRouter(
                        header: intl.balanceActionButtons_receive,
                        currency: currency,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.withdrawalStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        sAnalytics.receiveAssetView(
                          asset: currency.description,
                        );

                        sRouter.navigate(
                          CryptoDepositRouter(
                            header: intl.balanceActionButtons_receive,
                            currency: currency,
                          ),
                        );
                      },
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
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
                    sRouter.push(
                      CurrencySellRouter(
                        currency: currency,
                      ),
                    );
                  } else {
                    kycAlertHandler.handle(
                      status: kycState.sellStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {
                        sRouter.push(
                          CurrencySellRouter(
                            currency: currency,
                          ),
                        );
                      },
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
                    );
                  }
                },
                active: true,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
