import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
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
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(
      currencies,
      marketItem.associateAsset,
    );
    final isBalanceEmpty = areBalancesEmpty(currencies);
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final colors = sKit.colors;

    return SPaddingH24(
      child: Row(
        children: [
          if (marketItem.symbol == 'CPWR') ...[
            Expanded(
              child: SPrimaryButton1(
                name: '${intl.balanceActionButtons_buy} ${marketItem.name}',
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
          ] else ...[
            if (isBuyWithCurrencyAvailableFor(currency.symbol, currencies))
              Expanded(
                child: Column(
                  children: [
                    SimpleCircleButton(
                      defaultIcon: STopUpIcon(
                        color: colors.white,
                      ),
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
                            requiredVerifications:
                                kycState.requiredVerifications,
                          );
                        }
                      },
                    ),
                    const SpaceH9(),
                    Text(
                      intl.balanceActionButtons_buy,
                      style: sBodyText2Style,
                    ),
                  ],
                ),
              ),
            if (isBuyWithCurrencyAvailableFor(currency.symbol, currencies))
              const SpaceW11(),
            Expanded(
              child: Column(
                children: [
                  SimpleCircleButton(
                    defaultIcon: const SArrowDownIcon(),
                    onTap: () {
                      sAnalytics.receiveClick(
                          source: 'Market -> Asset -> Receive');
                      if (kycState.depositStatus ==
                          kycOperationStatus(KycStatus.allowed)) {
                        sAnalytics.receiveAssetView(
                            asset: currency.description);
                        sRouter.navigate(
                          CryptoDepositRouter(
                            header: intl.balanceActionButtons_receive,
                            currency: currency,
                          ),
                        );
                      } else {
                        kycAlertHandler.handle(
                          status: kycState.depositStatus,
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
                  ),
                  const SpaceH9(),
                  Text(
                    intl.balanceActionButtons_receive,
                    style: sBodyText2Style,
                  ),
                ],
              ),
            ),
            if (!marketItem.isBalanceEmpty) ...[
              const SpaceW11(),
              Expanded(
                child: Column(
                  children: [
                    SimpleCircleButton(
                      defaultIcon: const SArrowUpIcon(),
                      onTap: () {
                        if (kycState.sellStatus ==
                            kycOperationStatus(KycStatus.allowed)) {
                          showSendOptions(context, currency);
                        } else {
                          kycAlertHandler.handle(
                            status: kycState.sellStatus,
                            isProgress: kycState.verificationInProgress,
                            currentNavigate: () {
                              showSendOptions(context, currency);
                            },
                            requiredDocuments: kycState.requiredDocuments,
                            requiredVerifications:
                                kycState.requiredVerifications,
                          );
                        }
                      },
                    ),
                    const SpaceH9(),
                    Text(
                      intl.balanceActionButtons_send,
                      style: sBodyText2Style,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
