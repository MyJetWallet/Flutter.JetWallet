import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnCurrencyItem extends StatelessWidget {
  const EarnCurrencyItem({
    Key? key,
    this.onTap,
    required this.element,
  }) : super(key: key);

  final Function()? onTap;
  final CurrencyModel element;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
      onTap: onTap,
      child: SizedBox(
        height: 88.0,
        child: Column(
          children: [
            const SpaceH22(),
            SPaddingH24(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SNetworkSvg24(
                    url: element.iconUrl,
                  ),
                  const SpaceW10(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            element.description,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            element.symbol,
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceW10(),
                  SizedBox(
                    width: 158.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Baseline(
                          baseline: 18.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            '${element.apy.toStringAsFixed(0)}%'
                            ' ${intl.earnCurrencysItem_apy}',
                            style: sSubtitle2Style.copyWith(
                              color: colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SPaddingH24(
              child: SDivider(
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
