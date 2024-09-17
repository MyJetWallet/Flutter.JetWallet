import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

import '../../../helper/format_number.dart';

class MarketStatsBlock extends StatelessWidget {
  const MarketStatsBlock({
    super.key,
    required this.marketInfo,
    this.isCPower = false,
  });

  final MarketInfoResponseModel marketInfo;
  final bool isCPower;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        STableHeader(
          title: intl.marketStatsBlock_marketStats,
          size: SHeaderSize.m,
          needHorizontalPadding: false,
        ),
        const SizedBox(height: 8),
        TwoColumnCell(
          label: intl.market_market_cap,
          value: '${baseCurrency.prefix ?? ''}'
              ' ${formatNumber(marketInfo.marketCap.toDouble())}'
              '''${baseCurrency.prefix == null ? ' ${baseCurrency.symbol}' : ''}''',
          needHorizontalPadding: false,
        ),
        if (isCPower)
          TwoColumnCell(
            label: intl.marketStatsBlock_circSupply,
            value: formatNumber(marketInfo.supply.toDouble()),
            needHorizontalPadding: false,
          )
        else
          TwoColumnCell(
            label: '${intl.market_volume} (24${intl.h})',
            value: '${baseCurrency.prefix ?? ''}'
                ' ${formatNumber(marketInfo.dayVolume.toDouble())}'
                '''${baseCurrency.prefix == null ? ' ${baseCurrency.symbol}' : ''}''',
            needHorizontalPadding: false,
          ),
        TwoColumnCell(
          label: intl.market_circulating_supply,
          value: '${baseCurrency.prefix ?? ''}'
          ' ${formatNumber(marketInfo.supply.toDouble())}'
          '''${baseCurrency.prefix == null ? ' ${baseCurrency.symbol}' : ''}''',
          needHorizontalPadding: false,
        ),
      ],
    );
  }
}
