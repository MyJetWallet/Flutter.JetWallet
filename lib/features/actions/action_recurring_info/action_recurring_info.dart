import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_recurring_info/widgets/action_recurring_info_details.dart';
import 'package:jetwallet/features/actions/action_recurring_info/widgets/action_recurring_info_header.dart';
import 'package:jetwallet/features/actions/action_recurring_manage/action_recurring_manage.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

@RoutePage(name: 'ShowRecurringInfoActionRouter')
class ShowRecurringInfoAction extends StatelessObserverWidget {
  const ShowRecurringInfoAction({
    super.key,
    required this.recurringItem,
    required this.assetName,
  });

  final RecurringBuysModel recurringItem;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final scrollController = ScrollController();

    final sellCurrency = currencyFrom(
      currencies,
      recurringItem.fromAsset,
    );

    final buyCurrency = currencyFrom(
      currencies,
      recurringItem.toAsset,
    );

    final sellCurrencyAmount = volumeFormat(
      prefix: sellCurrency.prefixSymbol,
      decimal: Decimal.parse(
        recurringItem.totalFromAmount.toString(),
      ),
      accuracy: sellCurrency.accuracy,
      symbol: sellCurrency.symbol,
    );

    return Scaffold(
      bottomNavigationBar: ColoredBox(
        color: colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SSecondaryButton1(
              active: true,
              name: intl.actionRecurringInfo_manage,
              onTap: () {
                showRecurringManageAction(
                  context: context,
                  recurringItem: recurringItem,
                  assetName: assetName,
                  sellCurrencyAmount: sellCurrencyAmount,
                );
              },
            ),
          ),
        ),
      ),
      body: Material(
        color: colors.white,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              toolbarHeight: 410,
              pinned: true,
              backgroundColor: colors.white,
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace: SPaddingH24(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SSmallHeader(
                        title: '$assetName'
                            ' ${intl.actionRecurringInfo_recurringBuy}',
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ActionRecurringInfoHeader(
                            total: sellCurrencyAmount,
                            amount: volumeFormat(
                              prefix: buyCurrency.prefixSymbol,
                              decimal: Decimal.parse(
                                recurringItem.totalToAmount.toString(),
                              ),
                              accuracy: buyCurrency.accuracy,
                              symbol: buyCurrency.symbol,
                            ),
                          ),
                          ActionRecurringInfoDetails(
                            recurringItem: recurringItem,
                          ),
                          const SDivider(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TransactionsList(
              scrollController: scrollController,
              symbol: recurringItem.toAsset,
              isRecurring: true,
            ),
          ],
        ),
      ),
    );
  }
}
