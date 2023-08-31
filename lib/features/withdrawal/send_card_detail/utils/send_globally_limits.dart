import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

void showGlobalSendLimits({
  required BuildContext context,
  required Decimal minAmount,
  required Decimal maxAmount,
  required CurrencyModel currency,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      _GlobalSendLimits(
        minAmount: minAmount,
        maxAmount: maxAmount,
        currency: currency,
      ),
    ],
  );
}

class _GlobalSendLimits extends StatelessWidget {
  const _GlobalSendLimits({
    super.key,
    required this.minAmount,
    required this.maxAmount,
    required this.currency,
  });

  final Decimal minAmount;
  final Decimal maxAmount;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Opacity(
                opacity: 0,
                child: SEraseIcon(),
              ),
              Flexible(
                child: Text(
                  intl.send_globally_limits_text,
                  style: sTextH2Style.copyWith(
                    color: colors.black,
                  ),
                ),
              ),
              SIconButton(
                onTap: () {
                  Navigator.pop(context);
                },
                defaultIcon: const SEraseIcon(),
                pressedIcon: const SErasePressedIcon(),
              ),
            ],
          ),
          const SpaceH24(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_maxTransaction,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: currency.prefixSymbol,
                decimal: maxAmount,
                symbol: currency.symbol,
                accuracy: currency.accuracy,
              ),
            ),
          ),
          const SpaceH16(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_minTransaction,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: currency.prefixSymbol,
                decimal: minAmount,
                symbol: currency.symbol,
                accuracy: currency.accuracy,
              ),
            ),
          ),
          const SpaceH72(),
        ],
      ),
    );
  }
}
