import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_details_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_details_skeleton.dart';
import 'package:jetwallet/features/earn/widgets/position_audit_item.dart';
import 'package:jetwallet/features/earn/widgets/position_audit_item_veiw.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_month_separator.dart';
import 'package:jetwallet/features/wallet/helper/format_date.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/bottom_sheets/components/basic_bottom_sheet/show_basic_modal_bottom_sheet.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/utils/constants.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_networking/modules/signal_r/models/earn_audit_history_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

@RoutePage(name: 'EarnsDetailsRouter')
class EarnsDetailsScreen extends StatefulWidget {
  const EarnsDetailsScreen({
    required this.positionId,
    required this.assetName,
    super.key,
  });

  final String positionId;
  final String assetName;

  @override
  State<EarnsDetailsScreen> createState() => _EarnsDetailsScreenState();
}

class _EarnsDetailsScreenState extends State<EarnsDetailsScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<EarnsDetailsStore>(
      create: (context) => EarnsDetailsStore()..fetchPositionAudits(positionId: widget.positionId),
      child: Observer(
        builder: (context) {
          final store = Provider.of<EarnsDetailsStore>(context);
          final colors = sKit.colors;
          final currencies = sSignalRModules.currenciesWithHiddenList;

          scrollController.addListener(() {
            if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
              store.loadMorePositionAudits(positionId: widget.positionId);
            }
          });

          return SPageFrame(
            loaderText: '',
            color: colors.white,
            header: GlobalBasicAppBar(
              title: intl.earn_earns_details,
              subtitle: widget.assetName,
              hasRightIcon: false,
            ),
            child: store.isLoadingInitialData
                ? const EarnDetailsSkeleton()
                : CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      if (store.positionAuditsList.isEmpty)
                        const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        ),
                      SliverGroupedListView<EarnPositionAuditClientModel, String>(
                        sort: false,
                        elements: store.positionAuditsList,
                        groupBy: (positionAudit) {
                          return formatDate(
                            DateFormat('yyyy-MM-dd HH:mm').format(positionAudit.timestamp!),
                          );
                        },
                        groupSeparatorBuilder: (String date) {
                          return TransactionMonthSeparator(text: date);
                        },
                        itemBuilder: (context, positionAudit) {
                          final currency = currencyFrom(
                            currencies,
                            positionAudit.assetId ?? '',
                          );
                          if (positionAudit.auditEventType == AuditEventType.positionCloseRequest) {
                            return const SizedBox.shrink();
                          }
                          return PositionAuditItem(
                            key: ValueKey(positionAudit.id),
                            onTap: () {
                              sShowBasicModalBottomSheet(
                                children: [
                                  PositionAuditItemView(
                                    key: ValueKey('${positionAudit.id}_view'),
                                    positionAudit: positionAudit,
                                    earnPositionId: widget.positionId,
                                    onCopyAction: (string) {},
                                    asset: currency,
                                  ),
                                ],
                                scrollable: true,
                                context: context,
                              );
                            },
                            balanceChange: positionAuditClientModelBalanceChange(
                              positionAudit: positionAudit,
                              accuracy: currency.accuracy,
                              symbol: currency.symbol,
                            ),
                            icon: _transactionLabelIcon(
                              type: positionAudit.auditEventType,
                            ),
                            labele: positionAudit.assetId ?? '',
                            status: Status.completed,
                            timeStamp: positionAudit.timestamp != null
                                ? '${formatDateToDMY(positionAudit.timestamp?.toString())}'
                                    ', ${formatDateToHm(positionAudit.timestamp?.toString())}'
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

  Widget _transactionLabelIcon({
    required AuditEventType type,
  }) {
    final colors = sKit.colors;

    switch (type) {
      case AuditEventType.positionCreate:
      case AuditEventType.positionDeposit:
        return Assets.svg.medium.arrowDown.simpleSvg(
          width: 24,
          color: colors.green,
        );

      case AuditEventType.positionWithdraw:
      case AuditEventType.positionClose:
        return Assets.svg.medium.arrowUp.simpleSvg(
          width: 24,
          color: colors.red,
        );
      case AuditEventType.positionIncomePayroll:
        return Assets.svg.medium.percent.simpleSvg(
          width: 24,
          color: colors.blue,
        );
      case AuditEventType.undefined:
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }
}

String positionAuditClientModelBalanceChange({
  required EarnPositionAuditClientModel positionAudit,
  required String symbol,
  required int accuracy,
  bool showNegative = true,
}) {
  final Decimal amount;

  if (positionAudit.auditEventType == AuditEventType.positionCreate ||
      positionAudit.auditEventType == AuditEventType.positionDeposit) {
    amount = positionAudit.positionBaseAmountChange + positionAudit.positionIncomeAmountChange;
  } else if (positionAudit.auditEventType == AuditEventType.positionWithdraw ||
      positionAudit.auditEventType == AuditEventType.positionClose) {
    amount = positionAudit.positionBaseAmountChange + positionAudit.positionIncomeAmountChange;
  } else {
    amount = positionAudit.positionIncomeAmountChange;
  }

  return (showNegative ? amount : amount.abs()).toFormatCount(
    accuracy: accuracy,
    symbol: symbol,
  );
}
