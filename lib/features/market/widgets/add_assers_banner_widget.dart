import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class AddAssersBannerWidget extends StatelessWidget {
  const AddAssersBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      height: 92,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: colors.purpleGradient,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colors.black.withOpacity(0.11999999731779099),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.asset(
                  addAssetsBannerBg,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  intl.market_100_instruments,
                  style: STStyles.subtitle1.copyWith(
                    color: colors.white,
                    height: 1.2,
                  ),
                ),
                const _AddAssetsButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddAssetsButton extends StatelessWidget {
  const _AddAssetsButton();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            intl.market_add_assets,
            textAlign: TextAlign.center,
            style: STStyles.body1Bold.copyWith(
              color: colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
