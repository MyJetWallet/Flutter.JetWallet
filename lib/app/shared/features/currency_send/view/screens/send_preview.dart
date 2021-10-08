import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/loader.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../components/action_preview/action_preview_divider.dart';
import '../../../../components/action_preview/action_preview_row.dart';
import '../../../currency_withdraw/helper/user_will_receive.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';
import '../../notifier/send_preview_notifier/send_preview_notipod.dart';

class SendPreview extends HookWidget {
  const SendPreview({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(sendPreviewNotipod(withdrawal));
    final notifier = useProvider(sendPreviewNotipod(withdrawal).notifier);

    final currency = withdrawal.currency;
    final verb = withdrawal.dictionary.verb;

    return PageFrame(
      header: '$verb ${currency.description} by phone',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        children: [
          const Spacer(),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'You $verb to',
            value: state.phoneNumber,
          ),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'Amount to send',
            value: userWillreceive(
              currency: currency,
              amount: state.amount,
              addressIsInternal: false,
            ),
          ),
          const ActionPreviewDivider(),
          ActionPreviewRow(
            description: 'Fee',
            value: currency.withdrawalFeeWithSymbol,
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
              onTap: () => notifier.send(),
            )
        ],
      ),
    );
  }
}
