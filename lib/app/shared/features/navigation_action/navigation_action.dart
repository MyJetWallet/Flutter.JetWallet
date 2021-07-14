import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../components/action_sheet/action_sheet.dart';
import '../../components/action_sheet/components/action_sheet_button.dart';
import '../convert/view/convert.dart';
import 'actions/action_buy/action_buy.dart';
import 'actions/action_deposit/action_deposit.dart';
import 'actions/action_receive/action_receive.dart';
import 'actions/action_sell/action_sell.dart';
import 'actions/action_send/action_send.dart';
import 'actions/action_withdraw/action_withdraw.dart';

void showNavigationAction(BuildContext context, AppLocalizations intl) {
  showActionBottomSheet(
    sheetheight: 0.6.sh,
    context: context,
    children: [
      ActionSheetButton(
        title: intl.buy,
        description: intl.buyCryptoWithYourLocalCurrency,
        icon: FontAwesomeIcons.plus,
        onTap: () => navigatorPush(context, const ActionBuy()),
      ),
      ActionSheetButton(
        title: intl.sell,
        description: intl.sellCryptoToYourLocalCurrency,
        icon: FontAwesomeIcons.minus,
        onTap: () => navigatorPush(context, const ActionSell()),
      ),
      ActionSheetButton(
        title: intl.convert,
        description: intl.quicklySwapOneCryptoForAnother,
        icon: FontAwesomeIcons.exchangeAlt,
        onTap: () => navigatorPush(context, const Convert()),
      ),
      ActionSheetButton(
        title: intl.deposit,
        description: intl.depositWithFiat,
        icon: FontAwesomeIcons.creditCard,
        onTap: () => navigatorPush(context, const ActionDeposit()),
      ),
      ActionSheetButton(
        title: intl.withdraw,
        description: intl.withdrawCryptoToYourCreditCard,
        icon: FontAwesomeIcons.arrowRight,
        onTap: () => navigatorPush(context, const ActionWithdraw()),
      ),
      ActionSheetButton(
        title: intl.send,
        description: intl.sendCryptoToAnotherWallet,
        icon: FontAwesomeIcons.arrowUp,
        onTap: () => navigatorPush(context, const ActionSend()),
      ),
      ActionSheetButton(
        title: intl.receive,
        description: intl.receiveCryptoFromAnotherWallet,
        icon: FontAwesomeIcons.arrowDown,
        onTap: () => navigatorPush(context, const ActionReceive()),
      ),
    ],
  );
}
