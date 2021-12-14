import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../helper/format_date.dart';
import '../../../../notifier/operation_history_notipod.dart';
import 'card_block/cards_block.dart';
import 'transactions_list_item/transaction_list_item.dart';

class WalletBody extends StatefulHookWidget {
  const WalletBody({
    Key? key,
    required this.assetId,
    required this.currentPage,
  }) : super(key: key);

  final String assetId;
  final int currentPage;

  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        final transactionHistoryN = context.read(
          operationHistoryNotipod.notifier,
        );

        transactionHistoryN.operationHistory(widget.assetId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final transactionHistory = useProvider(operationHistoryNotipod);

    return Column(
      children: [
        CardBlock(
          currentPage: widget.currentPage,
          assetId: widget.assetId,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
          ),
          child: SizedBox(
            height: 0.6.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.assetId} Transactions',
                  textAlign: TextAlign.start,
                  style: sTextH4Style,
                ),
                const SpaceH20(),
                Expanded(
                  child: GroupedListView<OperationHistoryItem, String>(
                    elements: transactionHistory,
                    controller: _scrollController,
                    useStickyGroupSeparators: true,
                    stickyHeaderBackgroundColor: Colors.white,
                    groupBy: (transaction) {
                      return formatDate(transaction.timeStamp);
                    },
                    groupSeparatorBuilder: (String date) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Text(
                          date,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      );
                    },
                    groupComparator: (date1, date2) => 0,
                    itemBuilder: (context, transaction) => TransactionListItem(
                      transactionListItem: transaction,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
