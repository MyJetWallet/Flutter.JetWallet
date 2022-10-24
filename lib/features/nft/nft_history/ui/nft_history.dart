import 'package:flutter/material.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/wallet/helper/format_date.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transaction_month_separator.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

class NftHistoryScreen extends StatelessWidget {
  const NftHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final scrollController = ScrollController();
    final deviceSize = getIt.get<DeviceSize>().size;

    return Scaffold(
      backgroundColor: colors.white,
      body: CustomScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
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
                title: 'test',
              ),
            ),
          ),
          /*
          SliverPadding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 0,
            ),
            sliver: SliverGroupedListView<OperationHistoryItem, String>(
              elements: listToShow,
              groupBy: (transaction) {
                return formatDate(transaction.timeStamp);
              },
              sort: false,
              groupSeparatorBuilder: (String date) {
                return TransactionMonthSeparator(text: date);
              },
              itemBuilder: (context, transaction) {
                final index = listToShow.indexOf(transaction);
                final currentDate = formatDate(transaction.timeStamp);
                var nextDate = '';
                if (index != (listToShow.length - 1)) {
                  nextDate = formatDate(listToShow[index + 1].timeStamp);
                }
                final removeDividerForLastInGroup = currentDate != nextDate;

                return TransactionListItem(
                  transactionListItem: transaction,
                  removeDivider: removeDividerForLastInGroup,
                );
              },
            ),
          ),
          */
        ],
      ),
    );
  }
}
