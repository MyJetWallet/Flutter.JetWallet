import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../../../../helpers/format_currency_amount.dart';
import '../../../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../helper/market_item_from.dart';

class WalletCardCollapsed extends HookWidget {
  const WalletCardCollapsed({
    Key? key,
    required this.assetId,
    required this.walletBackground,
  }) : super(key: key);

  final String assetId;
  final String walletBackground;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final baseCurrency = useProvider(baseCurrencyPod);
    final colors = useProvider(sColorPod);

    Stack(
      children: [
        SvgPicture.asset(
          walletBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SPaddingH24(
          child: SSmallHeader(
            title: '${marketItem.name} wallet',
          ),
        ),
      ],
    );

    return Stack(
      children: [
        SvgPicture.asset(
          walletBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 204,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SPaddingH24(
                child: SSmallHeader(
                  title: '${marketItem.name} wallet',
                ),
              ),
              const Spacer(),
              Text(
                formatCurrencyAmount(
                  prefix: baseCurrency.prefix,
                  value: marketItem.baseBalance,
                  accuracy: baseCurrency.accuracy,
                  symbol: baseCurrency.symbol,
                ),
                style: sTextH5Style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                formatCurrencyAmount(
                  symbol: marketItem.id,
                  value: marketItem.assetBalance,
                  accuracy: marketItem.accuracy,
                  prefix: marketItem.prefixSymbol,
                ),
                style: sBodyText2Style.copyWith(color: colors.grey1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SpaceH14(),
            ],
          ),
        )
      ],
    );
  }
}
