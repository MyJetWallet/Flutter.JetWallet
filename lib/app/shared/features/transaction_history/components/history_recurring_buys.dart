import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../actions/action_recurring_buy/components/recurring_buys_item.dart';
import '../../actions/action_recurring_info/action_recurring_info.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import '../../wallet/helper/format_date.dart';
import '../../wallet/view/components/wallet_body/components/transaction_month_separator.dart';

class HistoryRecurringBuys extends HookWidget {
  const HistoryRecurringBuys({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final scrollController = useScrollController();
    final state = useProvider(recurringBuysNotipod);

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
          SliverGroupedListView<RecurringBuysModel, String>(
            elements: state.recurringBuys,
            groupBy: (recurring) {
              return formatDate(_removeZ(recurring.creationTime!));
            },
            sort: false,
            groupSeparatorBuilder: (String date) {
              return TransactionMonthSeparator(
                text: date,
              );
            },
            itemBuilder: (context, recurring) {
              final index = state.recurringBuys.indexOf(recurring);
              final currentDate = formatDate(_removeZ(recurring.creationTime!));
              var nextDate = '';
              if (index != (state.recurringBuys.length - 1)) {
                nextDate = formatDate(
                  _removeZ(state.recurringBuys[index + 1].creationTime!),
                );
              }
              final removeDividerForLastInGroup = currentDate != nextDate;

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
          ),
        ],
      ),
    );
  }

  String _removeZ(String data) {
    return data.split('Z').first;
  }
}
