import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_status_badge.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';
import '../../../wallet/helper/format_date_to_hm.dart';
import 'components/transaction_details_item.dart';
import 'components/transaction_details_value_text.dart';

class ReferralDetails extends StatelessWidget {
  const ReferralDetails({
    super.key,
    required this.transactionListItem,
    required this.onCopyAction,
  });

  final OperationHistoryItem transactionListItem;
  final Function(String) onCopyAction;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          _ReferralDetailsHeader(
            transactionListItem: transactionListItem,
          ),
          TransactionDetailsItem(
            text: intl.date,
            value: TransactionDetailsValueText(
              text: '${formatDateToDMY(transactionListItem.timeStamp)}'
                  ', ${formatDateToHm(transactionListItem.timeStamp)}',
            ),
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}

class _ReferralDetailsHeader extends StatelessWidget {
  const _ReferralDetailsHeader({
    required this.transactionListItem,
  });

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final paymentAsset = sSignalRModules.currenciesWithHiddenList
        .where(
          (element) => element.symbol == transactionListItem.assetId,
        )
        .firstOrNull;

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: iconUrlFrom(
            assetSymbol: transactionListItem.assetId,
          ),
          fromAssetDescription: paymentAsset?.description ?? transactionListItem.assetId,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${paymentAsset?.symbol}'
              : transactionListItem.balanceChange.toFormatCount(
                  symbol: transactionListItem.assetId,
                  accuracy: paymentAsset?.accuracy ?? 1,
                ),
          hasSecondAsset: false,
          isError: transactionListItem.status == Status.declined,
          isSmallerVersion: true,
        ),
        const SizedBox(height: 24),
        TransactionStatusBadge(status: transactionListItem.status),
        const SizedBox(height: 24),
      ],
    );
  }
}
