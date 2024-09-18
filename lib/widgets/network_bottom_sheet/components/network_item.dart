import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

class WithdrawalNetworkItem extends StatelessWidget {
  const WithdrawalNetworkItem({
    super.key,
    required this.network,
    required this.onTap,
  });

  final BlockchainModel network;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final currency = getIt.get<FormatService>().findCurrency(
          findInHideTerminalList: true,
          assetSymbol: network.info?.feeAsset ?? '',
        );

    return SimpleTableAccount(
      assetIcon: SizedBox(
        width: 32,
        height: 27,
        child: Stack(
          children: [
            NetworkIconWidget(
              currency.iconUrl,
            ),
            Positioned(
              left: 15,
              top: 9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: NetworkIconWidget(
                  width: 16,
                  height: 16,
                  currency.iconUrl,
                ),
              ),
            ),
          ],
        ),
      ),
      label: network.description,
      hasRightValue: false,
      supplement:
          '~ ${network.info?.time} minutes · ${intl.fee}: ${network.info?.feeAmount.toFormatCount(symbol: network.info?.feeAsset)}',
      onTableAssetTap: onTap,
    );
  }
}
