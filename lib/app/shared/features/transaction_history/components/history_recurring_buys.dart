import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../../../shared/helpers/analytics.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/are_balances_empty.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../actions/action_recurring_buy/components/recurring_buys_item.dart';
import '../../actions/action_recurring_info/action_recurring_info.dart';
import '../../actions/action_sell/action_sell.dart';
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import '../../wallet/view/components/wallet_body/components/transaction_month_separator.dart';

class HistoryRecurringBuys extends HookWidget {
  const HistoryRecurringBuys({Key? key,  this.from}) : super(key: key);
  final Source? from;
  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final scrollController = useScrollController();
    final state = useProvider(recurringBuysNotipod);
    final notifier = useProvider(recurringBuysNotipod.notifier);
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(kycAlertHandlerPod(context));
    final currencies = useProvider(currenciesPod);

    final screenHeight = MediaQuery.of(context).size.height;

    analytics(() => sAnalytics.recurringBuyView());

    return Material(
      color: colors.white,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            toolbarHeight: deviceSize.when(
              small: () {
                return 80;
              },
              medium: () {
                return 60;
              },
            ),
            pinned: true,
            backgroundColor: colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            flexibleSpace: SPaddingH24(
              child: SSmallHeader(
                title: intl.account_recurringBuy,
              ),
            ),
          ),
          if (state.recurringBuys.isNotEmpty)
            SliverGroupedListView<RecurringBuysModel, String>(
              elements: state.recurringBuys,
              groupBy: (recurring) {
                return recurring.toAsset;
              },
              sort: false,
              groupSeparatorBuilder: (String nameAsset) {
                return TransactionMonthSeparator(
                  text: nameAsset,
                );
              },
              itemBuilder: (context, recurring) {
                final index = state.recurringBuys.indexOf(recurring);
                final currentAsset = recurring.toAsset;
                var nextAsset = '';
                if (index != (state.recurringBuys.length - 1)) {
                  nextAsset = state.recurringBuys[index + 1].toAsset;
                }
                final removeDividerForLastInGroup = currentAsset != nextAsset;

                return RecurringBuysItem(
                  onTap: () {
                    navigatorPush(
                      context,
                      ShowRecurringInfoAction(
                        recurringItem: recurring,
                        assetName: recurring.toAsset,
                      ),
                    );
                  },
                  recurring: recurring,
                  removeDivider: removeDividerForLastInGroup,
                );
              },
            )
          else
            SliverToBoxAdapter(
              child: SizedBox(
                height: screenHeight - screenHeight * 0.161,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      intl.historyRecurringBuys_noTransactionsYet,
                      style: sTextH3Style,
                    ),
                    Text(
                      intl.historyRecurringBuy_text1,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                    const Spacer(),
                    if (!areBalancesEmpty(currencies))
                      SPaddingH24(
                        child: SSecondaryButton1(
                          active: true,
                          name: intl.actionBuy_actionWithOutRecurringBuyTitle1,
                          onTap: () {
                            if (kycState.sellStatus ==
                                kycOperationStatus(KycStatus.allowed)) {
                              notifier.handleNavigate(context, from);
                            } else {
                              kycAlertHandler.handle(
                                status: kycState.sellStatus,
                                kycVerified: kycState,
                                isProgress: kycState.verificationInProgress,
                                currentNavigate: () => showSellAction(context),
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
