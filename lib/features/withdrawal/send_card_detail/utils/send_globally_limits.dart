import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';

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
    final baseCurrency = sSignalRModules.baseCurrency;

    return SPaddingH24(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 24),
              const Spacer(),
              Text(
                intl.paymentMethodsSheet_cardsLimit,
                style: sTextH2Style.copyWith(
                  color: colors.black,
                ),
              ),
              const Spacer(),
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
            text: intl.paymentMethodsSheet_minTransaction,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: minAmount,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
                onlyFullPart: true,
              ),
            ),
          ),
          const SpaceH16(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_maxTransaction,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: maxAmount,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
                onlyFullPart: true,
              ),
            ),
          ),
          const SpaceH72(),
        ],
      ),
    );
  }
}