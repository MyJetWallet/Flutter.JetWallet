import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../actions/action_recurring_buy/components/recurring_buys_item.dart';
import '../../actions/action_recurring_info/action_recurring_info.dart';
import '../../actions/action_sell/action_sell.dart';
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import '../../wallet/view/components/wallet_body/components/transaction_month_separator.dart';

class HistoryRecurringBuys extends HookWidget {
  const HistoryRecurringBuys({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final scrollController = useScrollController();
    final state = useProvider(recurringBuysNotipod);
    final notifier = useProvider(recurringBuysNotipod.notifier);
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

    final screenHeight = MediaQuery.of(context).size.height;

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
            flexibleSpace: const SPaddingH24(
              child: SSmallHeader(
                title: 'Recurring buy',
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
                      'No transactions yet',
                      style: sTextH3Style,
                    ),
                    Text(
                      'Your transactions will appear here',
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                    const Spacer(),
                    SPaddingH24(
                      child: SSecondaryButton1(
                        active: true,
                        name: 'Setup recurring buy',
                        onTap: () {
                          if (kycState.sellStatus ==
                              kycOperationStatus(KycStatus.allowed)) {
                            notifier.handleNavigate(context);
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
