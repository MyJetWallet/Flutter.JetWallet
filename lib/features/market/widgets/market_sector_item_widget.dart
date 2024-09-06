import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/helper/sector_extensions.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

class MarketSectorItemWidget extends StatelessWidget {
  const MarketSectorItemWidget({super.key, required this.sector});

  final MarketSectorModel sector;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SafeGesture(
      onTap: () async {
        await sRouter.push(
          MarketSectorDetailsRouter(
            sector: sector,
          ),
        );
      },
      highlightColor: colors.gray2,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(
              sector.imageUrl,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sector.title,
            style: STStyles.body1Semibold,
          ),
          Text(
            '${sector.countOfTokens} tokens',
            style: STStyles.captionMedium.copyWith(
              color: colors.gray10,
            ),
          ),
        ],
      ),
    );
  }
}
