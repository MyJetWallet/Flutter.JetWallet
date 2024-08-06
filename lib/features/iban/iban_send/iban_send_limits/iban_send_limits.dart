import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';

void showIbanSendLimits({
  required BuildContext context,
  required CardLimitsModel cardLimits,
  CurrencyModel? currency,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      _SendIbanLimits(
        cardLimit: cardLimits,
        currency: currency,
      ),
    ],
  );
}

class _SendIbanLimits extends StatelessWidget {
  const _SendIbanLimits({
    this.currency,
    required this.cardLimit,
  });

  final CardLimitsModel cardLimit;
  final CurrencyModel? currency;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    return SPaddingH24(
      child: Column(
        children: [
          Text(
            intl.paymentMethodsSheet_cardsLimit,
            style: sTextH2Style.copyWith(
              color: colors.black,
            ),
          ),
          const SpaceH24(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_minTransaction,
            value: TransactionDetailsValueText(
              text: currency == null
                  ? cardLimit.minAmount.toFormatCount(
                      symbol: baseCurrency.symbol,
                      accuracy: 0,
                    )
                  : cardLimit.minAmount.toFormatCount(
                      symbol: currency?.symbol,
                      accuracy: 0,
                    ),
            ),
          ),
          const SpaceH16(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_maxTransaction,
            value: TransactionDetailsValueText(
              text: currency == null
                  ? cardLimit.maxAmount.toFormatCount(
                      symbol: baseCurrency.symbol,
                      accuracy: 0,
                    )
                  : cardLimit.maxAmount.toFormatCount(
                      symbol: currency!.symbol,
                      accuracy: 0,
                    ),
            ),
          ),
          const SpaceH72(),
        ],
      ),
    );
  }
}
