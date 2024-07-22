import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class EarnOfferItem extends StatelessWidget {
  const EarnOfferItem({
    required this.percentage,
    required this.cryptoName,
    required this.onTap,
    this.trailingIcon,
    this.isSingleOffer = false,
    super.key,
  });
  final String? percentage;
  final String cryptoName;
  final void Function()? onTap;
  final Widget? trailingIcon;
  final bool isSingleOffer;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    // TODO (Yaroslav): replace to component
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 12,
            top: 14,
            bottom: 14,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.grey4),
            borderRadius: BorderRadius.circular(12),
            color: colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (trailingIcon != null)
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: trailingIcon,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (percentage != null)
                        Text(
                          isSingleOffer
                              ? '${double.parse(percentage ?? '0').toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}%'
                              : '${intl.earn_up_to} ${double.parse(percentage ?? '0').toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}%',
                          style: STStyles.subtitle1.copyWith(
                            color: colors.black,
                          ),
                        ),
                      Text(
                        cryptoName,
                        style: STStyles.body1Semibold.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
                child: Assets.svg.medium.shevronRight.simpleSvg(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
