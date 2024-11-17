import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class STransaction extends StatelessWidget {
  const STransaction({
    super.key,
    required this.isLoading,
    required this.fromAssetIconUrl,
    this.fromAssetCustomIcon,
    required this.fromAssetDescription,
    required this.fromAssetValue,
    this.toAssetIconUrl,
    this.toAssetCustomIcon,
    this.toAssetDescription,
    this.toAssetValue,
    this.removeDefaultPaddings = false,
    this.isError = false,
    this.fromAssetBaseAmount,
    this.toAssetBaseAmount,
    this.hasSecondAsset = true,
    this.isSmallerVersion = false,
  });

  final bool isLoading;
  final String fromAssetIconUrl;
  final Widget? fromAssetCustomIcon;
  final String fromAssetDescription;
  final String fromAssetValue;
  final String? fromAssetBaseAmount;
  final String? toAssetIconUrl;
  final Widget? toAssetCustomIcon;
  final String? toAssetDescription;
  final String? toAssetValue;
  final String? toAssetBaseAmount;

  final bool removeDefaultPaddings;
  final bool isError;
  final bool hasSecondAsset;
  final bool isSmallerVersion;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      padding: removeDefaultPaddings ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AssetRowWidget(
            isLoading: isLoading,
            assetIconUrl: fromAssetIconUrl,
            assetDescription: fromAssetDescription,
            assetValue: fromAssetValue,
            customIcon: fromAssetCustomIcon,
            isError: isError,
            assetBaseAmount: fromAssetBaseAmount,
            isSmallerVersion: isSmallerVersion,
          ),
          if (hasSecondAsset) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: isSmallerVersion ? 8 : 12, vertical: isSmallerVersion ? 4 : 8),
              width: 16,
              height: 16,
              child: isError
                  ? Assets.svg.medium.close.simpleSvg(
                      width: 16,
                      height: 16,
                      color: colors.gray8,
                    )
                  : Assets.svg.medium.chevronDownDouble.simpleSvg(
                      width: 16,
                      height: 16,
                      color: colors.gray8,
                    ),
            ),
            _AssetRowWidget(
              isLoading: isLoading,
              assetIconUrl: toAssetIconUrl ?? '',
              assetDescription: toAssetDescription ?? '',
              assetValue: toAssetValue ?? '0',
              isSecandary: true,
              customIcon: toAssetCustomIcon,
              isError: isError,
              assetBaseAmount: toAssetBaseAmount,
              isSmallerVersion: isSmallerVersion,
            ),
          ],
        ],
      ),
    );
  }
}

class _AssetRowWidget extends StatelessWidget {
  const _AssetRowWidget({
    required this.isLoading,
    required this.assetIconUrl,
    required this.assetDescription,
    required this.assetValue,
    this.isSecandary = false,
    this.customIcon,
    this.isError = false,
    this.assetBaseAmount,
    this.isSmallerVersion = false,
  });

  final bool isLoading;
  final String assetIconUrl;
  final String assetDescription;
  final String assetValue;
  final bool isSecandary;
  final Widget? customIcon;
  final bool isError;
  final String? assetBaseAmount;
  final bool isSmallerVersion;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Row(
      children: [
        if (customIcon != null) ...[
          customIcon!,
        ] else ...[
          Image.network(
            assetIconUrl,
            width: isSmallerVersion ? 32 : 40,
            height: isSmallerVersion ? 32 : 40,
          ),
        ],
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maxLines: 2,
                assetDescription,
                style: STStyles.header5.copyWith(
                  color: colors.gray10,
                  fontSize: isSmallerVersion ? 12 : 14,
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
                  style: STStyles.header5.copyWith(
                    color: isError
                        ? colors.gray10
                        : isSecandary && !isSmallerVersion
                            ? colors.blue
                            : null,
                    decoration: isError ? TextDecoration.lineThrough : null,
                    fontSize: isSmallerVersion ? 20 : 24,
                  ),
                ),
              if (assetBaseAmount != null)
                if (isLoading) ...[
                  const SizedBox(height: 4),
                  SSkeletonLoader(
                    width: 80,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ] else
                  Text(
                    assetBaseAmount!,
                    style: STStyles.body2Semibold.copyWith(
                      color: colors.gray10,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
