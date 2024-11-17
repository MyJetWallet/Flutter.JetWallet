import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/screens/earn_details_screen.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/earn_audit_history_model.dart';

import '../../../../../../../../../core/di/di.dart';

class PositionAuditItemView extends StatelessObserverWidget {
  const PositionAuditItemView({
    super.key,
    required this.positionAudit,
    required this.onCopyAction,
    required this.earnPositionId,
    required this.asset,
  });

  final EarnPositionAuditClientModel positionAudit;
  final String earnPositionId;
  final Function(String) onCopyAction;
  final CurrencyModel asset;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        children: [
          const SizedBox(height: 24),
          _SellDetailsHeader(
            positionAudit: positionAudit,
          ),
          TransactionDetailsItem(
            text: intl.send_globally_date,
            value: TransactionDetailsValueText(
              text: positionAudit.timestamp != null
                  ? '${formatDateToDMY(positionAudit.timestamp?.toString())}'
                      ', ${formatDateToHm(positionAudit.timestamp?.toString())}'
                  : '',
            ),
          ),
          const SpaceH18(),
          TransactionDetailsItem(
            text: intl.earn_earn_account_id,
            value: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: TransactionDetailsValueText(
                      text: shortAddressFormTwo(earnPositionId),
                      maxLines: 1,
                    ),
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(earnPositionId),
                ],
              ),
            ),
          ),
          const SpaceH18(),
          if (positionAudit.id.isNotEmpty) ...[
            TransactionDetailsItem(
              text: intl.iban_send_history_transaction_id,
              value: Row(
                children: [
                  TransactionDetailsValueText(
                    text: shortAddressFormTwo(positionAudit.id),
                  ),
                  const SpaceW10(),
                  HistoryCopyIcon(positionAudit.id),
                ],
              ),
            ),
            const SpaceH18(),
          ],
          if (positionAudit.auditEventType == AuditEventType.positionIncomePayroll) ...[
            TransactionDetailsItem(
              text: intl.earn_base_amount,
              value: TransactionDetailsValueText(
                text: positionAudit.positionBaseAmount.toFormatCount(
                  accuracy: asset.accuracy,
                  symbol: asset.symbol,
                ),
              ),
            ),
            const SpaceH18(),
            TransactionDetailsItem(
              text: intl.earn_apy_rate,
              value: TransactionDetailsValueText(
                text: formatApyRate(positionAudit.offerApyRate),
              ),
            ),
            const SpaceH18(),
          ],
          Builder(
            builder: (context) {
              return ProcessingFeeRowWidget(
                fee: Decimal.zero.toFormatCount(
                  accuracy: asset.accuracy,
                  symbol: asset.symbol,
                ),
              );
            },
          ),
          const SpaceH18(),
          const SpaceH40(),
        ],
      ),
    );
  }
}

String formatApyRate(Decimal? apyRate) {
  if (apyRate == null) {
    return 'N/A';
  } else {
    return (apyRate * Decimal.fromInt(100)).toFormatPercentCount();
  }
}

class _SellDetailsHeader extends StatelessWidget {
  const _SellDetailsHeader({
    required this.positionAudit,
  });

  final EarnPositionAuditClientModel positionAudit;

  @override
  Widget build(BuildContext context) {
    final asset = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesWithHiddenList,
    ).firstWhere(
      (element) => element.symbol == positionAudit.assetId,
      orElse: () => CurrencyModel.empty(),
    );

    final isSavingIncome = positionAudit.auditEventType == AuditEventType.positionIncomePayroll;
    final isPositionRecived = positionAudit.auditEventType == AuditEventType.positionCreate ||
        positionAudit.auditEventType == AuditEventType.positionDeposit;

    return Column(
      children: [
        STransaction(
          removeDefaultPaddings: true,
          isLoading: false,
          fromAssetIconUrl: asset.iconUrl,
          fromAssetDescription: isSavingIncome
              ? intl.earn_revenue
              : isPositionRecived
                  ? intl.earn_crypto_wallet
                  : intl.earn_earn,
          fromAssetValue: getIt<AppStore>().isBalanceHide
              ? '**** ${asset.symbol}'
              : positionAuditClientModelBalanceChange(
                  showNegative: false,
                  accuracy: asset.accuracy,
                  positionAudit: positionAudit,
                  symbol: asset.symbol,
                ),
          toAssetIconUrl: asset.iconUrl,
          toAssetDescription: isPositionRecived ? intl.earn_earn : intl.earn_crypto_wallet,
          toAssetValue: isSavingIncome
              ? null
              : getIt<AppStore>().isBalanceHide
                  ? '**** ${asset.symbol}'
                  : positionAuditClientModelBalanceChange(
                      showNegative: false,
                      accuracy: asset.accuracy,
                      positionAudit: positionAudit,
                      symbol: asset.symbol,
                    ),
          isSmallerVersion: true,
          hasSecondAsset: !isSavingIncome,
        ),
        const SizedBox(height: 24),
        SBadge(
          lable: intl.transactionDetailsStatus_completed,
          icon: Assets.svg.medium.checkmarkAlt.simpleSvg(
            color: SColorsLight().green,
            width: 20,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
