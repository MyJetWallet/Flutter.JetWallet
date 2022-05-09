import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../market_details/helper/currency_from.dart';
import '../../wallet/view/components/wallet_body/components/transactions_list/transactions_list.dart';
import '../action_recurring_manage/action_recurring_manage.dart';
import 'components/action_recurring_info_details.dart';
import 'components/action_recurring_info_header.dart';

class ShowRecurringInfoAction extends HookWidget {
  const ShowRecurringInfoAction({
    Key? key,
    required this.recurringItem,
    required this.assetName,
  }) : super(key: key);

  final RecurringBuysModel recurringItem;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = context.read(currenciesPod);
    final scrollController = useScrollController();

    final sellCurrency = currencyFrom(
      currencies,
      recurringItem.fromAsset,
    );

    final buyCurrency = currencyFrom(
      currencies,
      recurringItem.toAsset,
    );

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: SSecondaryButton1(
          active: true,
          name: 'Manage',
          onTap: () {
            showRecurringManageAction(
              context: context,
              recurringItem: recurringItem,
            );
          },
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
                        title: '$assetName recurring buy',
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ActionRecurringInfoHeader(
                            total: '${sellCurrency.prefixSymbol ?? ''}'
                                '${recurringItem.totalFromAmount} '
                                '${sellCurrency.prefixSymbol != null ? '' : sellCurrency.symbol}',
                            amount: '${buyCurrency.prefixSymbol ?? ''}'
                                '${recurringItem.totalToAmount} '
                                '${buyCurrency.prefixSymbol != null ? '' : buyCurrency.symbol}',
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
