import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../auth/shared/helpers/open_email_app.dart';
import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../models/currency_model.dart';
import '../../notifier/withdrawal_confirm_notifier/withdrawal_confirm_notipod.dart';

class WithdrawalConfirm extends HookWidget {
  const WithdrawalConfirm({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    useProvider(withdrawalConfirmNotipod(currency));

    return PageFrame(
      header: 'Confirm withdraw request',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH20(),
          // TODO remove hardcode
          Text(
            'Confirm your withdrawal request by opening the link in '
            'the email we sent to: email@email.com',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          const SpaceH20(),
          Text(
            'This link expires in 1 hour',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
          InkWell(
            onTap: () {
              // TODO add resend
            },
            child: Text(
              'Resend',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Spacer(),
          AppButtonSolid(
            name: 'Open Email App',
            onTap: () => openEmailApp(context),
          ),
        ],
      ),
    );
  }
}
