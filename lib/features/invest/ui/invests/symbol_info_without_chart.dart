import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';

import '../../../../utils/helpers/icon_url_from.dart';
import '../../helpers/percent_info.dart';

class SymbolInfoWithoutChart extends StatelessObserverWidget {
  const SymbolInfoWithoutChart({
    super.key,
    required this.instrument,
    required this.price,
    required this.percent,
    required this.onTap,
  });

  final InvestInstrumentModel instrument;
  final String price;
  final Decimal percent;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        width: MediaQuery.of(context).size.width - 48,
        child: Row(
          children: [
            Row(
              children: [
                SvgPicture.network(
                  iconUrlFrom(assetSymbol: instrument.name ?? ''),
                  width: 32.0,
                  height: 32.0,
                  placeholderBuilder: (_) {
                    return const SAssetPlaceholderIcon();
                  },
                ),
                const SpaceW4(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instrument.name ?? '',
                      style: STStyles.header4SMInvest.copyWith(
                        color: colors.black,
                      ),
                    ),
                    const SpaceH2(),
                    Text(
                      instrument.description ?? '',
                      style: STStyles.body2InvestM.copyWith(
                        color: colors.grey2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: STStyles.header4SMInvest.copyWith(
                      color: colors.black,
                    ),
                  ),
                  const SpaceH2(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        percent.toDouble().toFormatPercentPriceChange(),
                        overflow: TextOverflow.ellipsis,
                        style: STStyles.body3InvestSM.copyWith(
                          color: percent == Decimal.zero
                              ? colors.grey3
                              : percent > Decimal.zero
                                  ? colors.green
                                  : colors.red,
                        ),
                      ),
                      percentIcon(percent),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
