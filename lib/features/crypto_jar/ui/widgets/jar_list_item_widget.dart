import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/crypto_jar/helpers/jar_extension.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

class JarListItemWidget extends HookWidget {
  const JarListItemWidget({
    required this.jar,
    super.key,
  });

  final JarResponseModel jar;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: () {
        getIt.get<EventBus>().fire(EndReordering());

        sAnalytics.jarTapOnButtonJarItemOnDashboard(
          jarName: jar.title,
        );

        getIt.get<JarsStore>().selectedJar = jar;
        getIt<AppRouter>().push(
          JarRouter(
            hasLeftIcon: true,
          ),
        );
      },
      highlightColor: SColorsLight().gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: Container(
        height: 96.0,
        width: double.infinity,
        color: isHighlated.value ? SColorsLight().gray2 : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 15.0,
        ),
        child: Row(
          children: [
            jar.getIcon(height: 64.0, width: 64.0),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      jar.title,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: STStyles.subtitle1.copyWith(
                        color: SColorsLight().black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  if (jar.status == JarStatus.closed)
                    Container(
                      height: 20.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: SColorsLight().gray2,
                      ),
                      child: Text(
                        intl.jar_closed,
                        style: STStyles.captionBold.copyWith(
                          color: SColorsLight().gray8,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              getIt<AppStore>().isBalanceHide
                  ? '**** ${jar.assetSymbol}'
                  : Decimal.parse(jar.balance.toString()).toFormatCount(
                      accuracy: 2,
                      symbol: jar.assetSymbol,
                    ),
              style: STStyles.subtitle1.copyWith(
                color: SColorsLight().black,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        JarProgressBar(
          progress: jar.balance / jar.target,
          isClosed: jar.status == JarStatus.closed,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            Text(
              getIt<AppStore>().isBalanceHide
                  ? '******* ${jar.assetSymbol}' : '${Decimal.parse(jar.balance.toString()).toFormatCount(
                accuracy: 2,
                symbol: jar.assetSymbol,
              )} / ${Decimal.parse(jar.target.toString()).toFormatCount(
                accuracy: 0,
                symbol: jar.assetSymbol,
              )}',
              style: STStyles.body2Medium.copyWith(
                color: SColorsLight().gray10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class JarProgressBar extends StatelessWidget {
  const JarProgressBar({
    required this.progress,
    this.isClosed = false,
    super.key,
  });

  final double progress;
  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final primaryWidth = totalWidth * (progress > 1 ? 1 : progress);
        final overflowWidth = progress > 1 ? totalWidth * ((progress - 1) / progress) : 0.0;

        return Container(
          width: totalWidth,
          height: 6,
          decoration: BoxDecoration(
            color: SColorsLight().gray4,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Container(
                width: primaryWidth,
                decoration: BoxDecoration(
                  color: isClosed ? SColorsLight().gray8 : null,
                  gradient: isClosed
                      ? null
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
                        ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              if (overflowWidth > 0 && !isClosed)
                Positioned(
                  right: 0,
                  child: Container(
                    width: overflowWidth,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF6825E), Color(0xFFF75F47)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
