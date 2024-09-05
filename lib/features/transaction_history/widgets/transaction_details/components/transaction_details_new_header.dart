import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_skeleton_text_loader.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class TransactionNewHeader extends StatelessWidget {
  const TransactionNewHeader({
    required this.isLoading,
    required this.assetIconUrl,
    required this.assetDescription,
    required this.assetValue,
    this.customIcon,
    this.isError = false,
    this.assetBaseAmount,
  });

  final bool isLoading;
  final String assetIconUrl;
  final String assetDescription;
  final String assetValue;
  final Widget? customIcon;
  final bool isError;
  final String? assetBaseAmount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        if (customIcon != null) ...[
          customIcon!,
        ] else ...[
          NetworkIconWidget(
            assetIconUrl,
            width: 32,
            height: 32,
          ),
        ],
        const SpaceW12(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assetDescription,
              style: sCaptionTextStyle.copyWith(
                color: colors.grey1,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isLoading)
              SSkeletonTextLoader(
                width: 120,
                height: 32,
                borderRadius: BorderRadius.circular(4),
              )
            else
              Text(
                assetValue,
                style: sTextH5Style.copyWith(
                  color: isError ? colors.grey1 : null,
                  decoration: isError ? TextDecoration.lineThrough : null,
                ),
              ),
            if (assetBaseAmount != null)
              Text(
                assetBaseAmount!,
                style: sCaptionTextStyle.copyWith(
                  color: colors.grey1,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
