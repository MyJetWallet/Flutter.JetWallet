import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/earn_details_skeleton.dart';
import 'package:jetwallet/features/earn/widgets/position_audit_item.dart';
import 'package:jetwallet/features/simple_coin/store/simple_coin_transaction_history_store.dart';
import 'package:jetwallet/features/wallet/helper/format_date.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transaction_month_separator.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/simple_coin_history_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

@RoutePage(name: 'SimpleCoinTransactionHistoryRoute')
class SimpleCoinTransactionHistoryScreen extends StatefulWidget {
  const SimpleCoinTransactionHistoryScreen({super.key});

  @override
  State<SimpleCoinTransactionHistoryScreen> createState() => _SimpleCoinTransactionHistoryScreenState();
}

class _SimpleCoinTransactionHistoryScreenState extends State<SimpleCoinTransactionHistoryScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SimpleCoinTransactionHistoryStore>(
      create: (context) => SimpleCoinTransactionHistoryStore()..fetchPositionAudits(),
      child: Observer(
        builder: (context) {
          final store = Provider.of<SimpleCoinTransactionHistoryStore>(context);
          final colors = sKit.colors;

          scrollController.addListener(() {
            if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
              store.loadMorePositionAudits();
            }
          });

          return SPageFrame(
            loaderText: '',
            color: colors.white,
            header: GlobalBasicAppBar(
              title: intl.simplecoin_transaction_historyr,
              subtitle: 'SMPL',
              hasRightIcon: false,
            ),
            child: store.isLoadingInitialData
                ? const EarnDetailsSkeleton()
                : CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      if (store.historyItems.isEmpty)
                        const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        ),
                      SliverGroupedListView<SimpleCoinHistoryItemModel, String>(
                        sort: false,
                        elements: store.historyItems,
                        groupBy: (positionAudit) {
                          return formatDate(DateFormat('yyyy-MM-dd HH:mm').format(positionAudit.createdAt!));
                        },
                        groupSeparatorBuilder: (String date) {
                          return TransactionMonthSeparator(text: date);
                        },
                        itemBuilder: (context, positionAudit) {
                          return PositionAuditItem(
                            key: ValueKey(positionAudit.id),
                            onTap: () {},
                            balanceChange: volumeFormat(
                              decimal: positionAudit.amount,
                              symbol: 'SMPL',
                            ),
                            icon: Assets.svg.medium.arrowDown.simpleSvg(
                              width: 24,
                              color: colors.green,
                            ),
                            labele: 'SMPL',
                            status: Status.completed,
                            timeStamp: positionAudit.completedAt != null
                                ? '${formatDateToDMY(positionAudit.completedAt?.toString())}'
                                    ', ${formatDateToHm(positionAudit.completedAt?.toString())}'
                                : '',
                            labelIcon: const SizedBox.shrink(),
                          );
                        },
                      ),
                      if (store.isLoadingPagination)
                        SliverToBoxAdapter(
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: colors.grey5,
                              shape: BoxShape.circle,
                            ),
                            child: const RiveAnimation.asset(
                              loadingAnimationAsset,
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}