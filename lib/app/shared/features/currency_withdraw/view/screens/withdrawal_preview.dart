import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/loader.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../components/action_preview/action_preview_divider.dart';
import '../../../../components/action_preview/action_preview_row.dart';
import '../../../../helpers/short_address_form.dart';
import '../../../../models/currency_model.dart';
import '../../helper/user_will_receive.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_notipod.dart';

class WithdrawalPreview extends HookWidget {
  const WithdrawalPreview({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(withdrawalPreviewNotipod(currency));
    final notifier = useProvider(withdrawalPreviewNotipod(currency).notifier);

    return PageFrame(
      header: 'Withdraw ${currency.description} (${currency.symbol})',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        children: [
          const Spacer(),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'Withdraw to',
            value: shortAddressForm(state.address),
          ),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'You will receive',
            value: userWillreceive(
              currency: currency,
              amount: state.amount,
              addressIsInternal: state.addressIsInternal,
            ),
          ),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'Fee',
            value: state.addressIsInternal
                ? 'No fee'
                : currency.withdrawaFeeWithSymbol,
          ),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'Total',
            value: '${state.amount} ${currency.symbol}',
          ),
          const SpaceH20(),
          if (state.loading)
            const Loader()
          else
            AppButtonSolid(
              name: 'Confirm',
              onTap: () => notifier.withdraw(),
            )
        ],
      ),
    );
  }
}
