import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../helpers/is_buy_with_currency_available_for.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_buy/view/curency_buy.dart';
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../action_recurring_buy/action_with_out_recurring_buy.dart';
import '../helpers/show_currency_search.dart';
import '../shared/components/action_bottom_sheet_header.dart';
import '../shared/notifier/action_search_notipod.dart';
import 'components/action_buy_subheader.dart';

/// Checks KYC elegebility status and shows appropriate action
void showBuyAction({
  bool shouldPop = true,
  bool showRecurring = false,
  required bool fromCard,
  required BuildContext context,
}) {
  final kyc = context.read(kycNotipod);
  final handler = context.read(kycAlertHandlerPod(context));

  void showAction() => _showBuyAction(
        shouldPop: shouldPop,
        showRecurring: showRecurring,
        context: context,
        fromCard: fromCard,
      );

  if (kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) {
    showAction();
  } else {
    if (shouldPop) Navigator.pop(context);
    handler.handle(
      status: kyc.depositStatus,
      kycVerified: kyc,
      isProgress: kyc.verificationInProgress,
      currentNavigate: () => showAction(),
    );
  }
}

void _showBuyAction({
  required bool shouldPop,
  required bool showRecurring,
  required bool fromCard,
  required BuildContext context,
}) {
  final intl = context.read(intlPod);

  final showSearch = showBuyCurrencySearch(
    context,
    fromCard: fromCard,
  );

  if (shouldPop) Navigator.pop(context); // close BasicBottomSheet from Menu

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.actionBuy_bottomSheetHeaderName1,
      showSearch: showSearch,
      onChanged: (String value) {
        context.read(actionSearchNotipod.notifier).search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionBuy(
        fromCard: fromCard,
        showRecurring: showRecurring,
      )
    ],
  );

  sAnalytics.buySheetView();
}

class _ActionBuy extends HookWidget {
  const _ActionBuy({
    Key? key,
    required this.fromCard,
    required this.showRecurring,
  }) : super(key: key);

  final bool fromCard;
  final bool showRecurring;

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(actionSearchNotipod);
    final intl = useProvider(intlPod);

    void _onItemTap(CurrencyModel currency, bool fromCard) {
      sAnalytics.buyView(
        Source.quickActions,
        currency.description,
      );

      if (showRecurring) {
        showActionWithoutRecurringBuy(
          context: context,
          title: intl.actionBuy_actionWithOutRecurringBuyTitle1,
          onItemTap: (RecurringBuysType type) {
            Navigator.pop(context);
            navigatorPushReplacement(
              context,
              CurrencyBuy(
                currency: currency,
                fromCard: false,
                recurringBuysType: type,
              ),
            );
          },
        );
      } else {
        navigatorPushReplacement(
          context,
          CurrencyBuy(
            currency: currency,
            fromCard: fromCard,
          ),
        );
      }
    }

    return Column(
      children: [
        const SpaceH10(),
        if (_displayDivider(state.filteredCurrencies, currencies))
          ActionBuySubheader(
            text: fromCard
                ? intl.actionBuy_bottomSheetItemTitle1
                : intl.actionBuy_bottomSheetItemTitle2,
          ),
        for (final currency in state.filteredCurrencies) ...[
          if (currency.supportsAtLeastOneBuyMethod)
            SMarketItem(
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              name: currency.description,
              price: marketFormat(
                prefix: baseCurrency.prefix,
                decimal: baseCurrency.symbol == currency.symbol
                    ? Decimal.one
                    : currency.currentPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: currency.symbol,
              last: currency == state.buyFromCardCurrencies.last,
              percent: currency.dayPercentChange,
              onTap: () => _onItemTap(currency, fromCard),
            ),
        ],
        if (!fromCard) ...[
          const SpaceH10(),
          if (_displayDividerCurrencyAvailable(
            state.filteredCurrencies,
            currencies,
          ))
            ActionBuySubheader(
              text: intl.actionBuy_actionWithOutRecurringBuyTitle2,
            ),
          for (final currency in state.filteredCurrencies) ...[
            if (!currency.supportsAtLeastOneBuyMethod)
              if (isBuyWithCurrencyAvailableFor(currency.symbol, currencies))
                SMarketItem(
                  icon: SNetworkSvg24(
                    url: currency.iconUrl,
                  ),
                  name: currency.description,
                  price: marketFormat(
                    prefix: baseCurrency.prefix,
                    decimal: baseCurrency.symbol == currency.symbol
                        ? Decimal.one
                        : currency.currentPrice,
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  ),
                  ticker: currency.symbol,
                  last: currency == state.filteredCurrencies.last,
                  percent: currency.dayPercentChange,
                  onTap: () => _onItemTap(currency, false),
                ),
          ],
        ],
      ],
    );
  }

  bool _displayDivider(
    List<CurrencyModel> filteredCurrencies,
    List<CurrencyModel> currencies,
  ) {
    for (final currency in filteredCurrencies) {
      if (currency.supportsAtLeastOneBuyMethod) {
        return true;
      }
    }
    return false;
  }

  bool _displayDividerCurrencyAvailable(
    List<CurrencyModel> filteredCurrencies,
    List<CurrencyModel> currencies,
  ) {
    for (final currency in filteredCurrencies) {
      if (!currency.supportsAtLeastOneBuyMethod) {
        if (isBuyWithCurrencyAvailableFor(currency.symbol, currencies)) {
          return true;
        }
      }
    }
    return false;
  }
}
