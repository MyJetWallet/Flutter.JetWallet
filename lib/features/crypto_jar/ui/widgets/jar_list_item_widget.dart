import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/helpers/jar_extension.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

class JarListItemWidget extends StatelessWidget {
  const JarListItemWidget({
    required this.jar,
    super.key,
  });

  final JarResponseModel jar;

  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: () {
        getIt<AppRouter>().push(
          JarRouter(
            jar: jar,
            hasLeftIcon: true,
          ),
        );
      },
      child: Container(
        height: 96.0,
        width: double.infinity,
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
              child: Text(
                jar.title,
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
            const SizedBox(
              width: 4.0,
            ),
            Text(
              Decimal.parse(jar.balance.toString()).toFormatCount(
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
              '${Decimal.parse(jar.balance.toString()).toFormatCount(
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
        final progressBarWidth = constraints.maxWidth * progress;

        return Container(
          width: constraints.maxWidth,
          height: 6,
          decoration: BoxDecoration(
            color: SColorsLight().gray4,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Container(
                width: progressBarWidth,
                decoration: BoxDecoration(
                  color: isClosed ? SColorsLight().gray8 : null,
                  gradient: isClosed ? null : SColorsLight().purpleGradient,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
