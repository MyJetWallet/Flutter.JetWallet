import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/helper/sector_extensions.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

class MarketSectorItemWidget extends StatelessWidget {
  const MarketSectorItemWidget({super.key, required this.sector});

  final MarketSectorModel sector;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SafeGesture(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        getIt.get<EventBus>().fire(EndReordering());
        await sRouter.push(
          MarketSectorDetailsRouter(
            sector: sector,
          ),
        );
      },
      highlightColor: colors.gray2,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(64),
            child: CachedNetworkImage(
              imageUrl: sector.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (_, __) {
                return SSkeletonLoader(
                  width: 64,
                  height: 64,
                  borderRadius: BorderRadius.circular(64),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sector.title,
            style: STStyles.body1Semibold,
          ),
          Text(
            '${sector.countOfTokens} ${sector.countOfTokens == 1 ? intl.market_token : intl.market_tokens}',
            style: STStyles.captionMedium.copyWith(
              color: colors.gray10,
            ),
          ),
        ],
      ),
    );
  }
}
