import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../models/currency_model.dart';
import '../../currency_withdraw/model/withdrawal_model.dart';
import '../../currency_withdraw/view/currency_withdraw.dart';
import 'components/send_option_card.dart';
import 'screens/send_input_phone.dart';

class SendOptions extends HookWidget {
  const SendOptions({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      onBackButton: () => Navigator.pop(context),
      child: Column(
        children: [
          Text(
            'How do you want to send crypto?',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          SendOptionCard(
            icon: FontAwesomeIcons.mobileAlt,
            title: 'Send by phone',
            description: 'Just choose friend from contacts',
            onTap: () {
              navigatorPush(
                context,
                SendInputPhone(
                  withdrawal: WithdrawalModel(
                    currency: currency,
                  ),
                ),
              );
            },
          ),
          const SpaceH8(),
          SendOptionCard(
            icon: FontAwesomeIcons.wallet,
            title: 'Send by wallet',
            description: 'Send to any wallet (address required)',
            onTap: () {
              navigatorPush(
                context,
                CurrencyWithdraw(
                  withdrawal: WithdrawalModel(
                    currency: currency,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
