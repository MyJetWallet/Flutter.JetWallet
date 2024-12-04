import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CryptoCardPriceWidget extends StatefulWidget {
  const CryptoCardPriceWidget({
    required this.userPrice,
    required this.regularPrice,
    required this.assetSymbol,
    required this.discount,
    super.key,
  });

  final Decimal userPrice;
  final Decimal regularPrice;
  final String assetSymbol;
  final Decimal discount;

  @override
  State<CryptoCardPriceWidget> createState() => _CryptoCardPriceWidgetState();
}

class _CryptoCardPriceWidgetState extends State<CryptoCardPriceWidget> {
  bool startAnimation = false;
  bool startUserPriceAnimation = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 650)).then((_) {
      setState(() {
        startAnimation = true;
      });
      Future.delayed(const Duration(milliseconds: 360)).then((_) {
        setState(() {
          startUserPriceAnimation = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    if (widget.regularPrice != widget.userPrice) {
      return Text(
        widget.userPrice.toFormatSum(
          symbol: widget.assetSymbol,
        ),
        style: STStyles.header5,
      );
    } else {
      return SizedBox(
        height: 32.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32.0,
              child: AnimatedCrossFade(
                firstChild: Text(
                  widget.userPrice.toFormatSum(
                    symbol: widget.assetSymbol,
                  ),
                  style: STStyles.header5,
                ),
                secondChild: const SizedBox(
                  height: 32.0,
                ),
                alignment: Alignment.centerLeft,
                crossFadeState: startUserPriceAnimation ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 600),
              ),
            ),
            const SpaceW6(),
            SizedBox(
              height: 32.0,
              child: AnimatedContainer(
                padding: EdgeInsets.only(top: startAnimation ? 3.0 : 0.0),
                alignment: Alignment.centerLeft,
                duration: const Duration(milliseconds: 400),
                child: AnimatedDefaultTextStyle(
                  style: STStyles.header5.copyWith(
                    fontSize: startAnimation ? 16.0 : 24.0,
                    height: 1.5,
                    // height: startAnimation ? 1.5 : 1.28,
                    color: startAnimation ? SColorsLight().gray8 : SColorsLight().black,
                    decoration: startAnimation ? TextDecoration.lineThrough : null,
                  ),
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    widget.regularPrice.toFormatSum(
                      symbol: widget.assetSymbol,
                    ),
                  ),
                ),
              ),
            ),
            const SpaceW6(),
            AnimatedOpacity(
              opacity: startAnimation ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 900),
              child: Container(
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: colors.red),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  intl.crypto_card_create_save(widget.discount.toFormatPercentCount()),
                  style: STStyles.body2Semibold.copyWith(
                    color: colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
