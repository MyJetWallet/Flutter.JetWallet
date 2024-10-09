import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

class WithdrawalNetworkItem extends StatelessWidget {
  const WithdrawalNetworkItem({
    super.key,
    required this.network,
    required this.onTap,
    required this.iconUrl,
  });
  final BlockchainModel network;
  final void Function() onTap;
  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    final networkInfo = network.info;

    final feeAsset = getIt.get<FormatService>().findCurrency(
          findInHideTerminalList: true,
          assetSymbol: networkInfo?.feeAsset ?? '',
        );

    return SimpleTableAccount(
      assetIcon: SizedBox(
        width: 32,
        height: 27,
        child: Stack(
          children: [
            NetworkIconWidget(
              iconUrl,
            ),
            if (networkInfo != null)
              Positioned(
                left: 15,
                top: 9,
                child: CachedNetworkImage(
                  imageUrl: iconUrlFrom(assetSymbol: networkInfo.network),
                  width: 16,
                  height: 16,
                  errorWidget: (context, url, error) => const SizedBox(),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    );
                  },
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                ),
              ),
          ],
        ),
      ),
      label: network.description,
      hasRightValue: false,
      supplement: networkInfo != null
          ? '~ ${networkInfo.time} ${networkInfo.time == 1 ? intl.withdrawal_network_minute : intl.withdrawal_network_minutes} · ${intl.fee}: ${networkInfo.feeAmount.toFormatCount(symbol: feeAsset.symbol)}'
          : null,
      onTableAssetTap: onTap,
    );
  }
}
