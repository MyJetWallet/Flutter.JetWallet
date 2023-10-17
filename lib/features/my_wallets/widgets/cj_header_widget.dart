import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class CJHeaderWidget extends StatelessWidget {
  const CJHeaderWidget({
    super.key,
    required this.eurCurr,
    required this.bankingAccount,
  });

  final CurrencyModel eurCurr;
  final SimpleBankingAccount bankingAccount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final top = c.biggest.height;

        return FlexibleSpaceBar(
          title: Text(
            volumeFormat(
              decimal: bankingAccount.balance ?? Decimal.zero,
              accuracy: eurCurr.accuracy,
              symbol: eurCurr.symbol,
            ),
            style: top > 131
                ? sTextH3Style.copyWith(
                    color: sKit.colors.black,
                  )
                : sTextH5Style.copyWith(
                    color: sKit.colors.black,
                  ),
          ),
          centerTitle: true,
          titlePadding: EdgeInsets.only(bottom: top > 131 ? 40 : 26),
          background: Container(
            padding: EdgeInsets.only(
              top: 35,
              left: MediaQuery.of(context).size.width * .25,
            ),
            color: sKit.colors.extraGreenLight,
            alignment: Alignment.centerRight,
            width: double.infinity,
            child: Image.asset(
              simpleWalletShape,
            ),
          ),
        );
      },
    );
  }
}
