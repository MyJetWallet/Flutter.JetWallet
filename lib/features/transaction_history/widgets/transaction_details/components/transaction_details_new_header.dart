import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
    final colors = SColorsLight();

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
              style: STStyles.captionMedium.copyWith(
                color: colors.gray10,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isLoading)
              SSkeletonLoader(
                width: 120,
                height: 32,
                borderRadius: BorderRadius.circular(4),
              )
            else
              Text(
                assetValue,
                style: STStyles.header6.copyWith(
                  color: isError ? colors.gray10 : null,
                  decoration: isError ? TextDecoration.lineThrough : null,
                ),
              ),
            if (assetBaseAmount != null)
              Text(
                assetBaseAmount!,
                style: STStyles.captionMedium.copyWith(
                  color: colors.gray10,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
