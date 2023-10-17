import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class CJHeaderWidget extends StatelessWidget {
  const CJHeaderWidget({super.key, required this.eurCurr});

  final CurrencyModel eurCurr;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final top = c.biggest.height;

        return FlexibleSpaceBar(
          title: Text(
            eurCurr.volumeAssetBalance,
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
