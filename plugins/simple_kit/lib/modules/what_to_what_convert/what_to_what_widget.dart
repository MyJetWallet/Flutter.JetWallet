import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/24x24/public/chevron_down_double/simple_chevron_down_double_icon.dart';
import 'package:simple_kit/simple_kit.dart';

class WhatToWhatConvertWidget extends StatelessWidget {
  const WhatToWhatConvertWidget({
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
    final colors = sKit.colors;

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
                  ? SCloseIcon(
                      color: colors.grey2,
                    )
                  : SChevronDownDoubleIcon(
                      color: colors.grey2,
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
    final colors = sKit.colors;

    return Row(
      children: [
        if (customIcon != null) ...[
          customIcon!,
        ] else ...[
          SNetworkSvg(
            url: assetIconUrl,
            width: isSmallerVersion ? 32 : 40,
            height: isSmallerVersion ? 32 : 40,
          ),
        ],
        const SpaceW12(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assetDescription,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
                fontWeight: FontWeight.w600,
                fontSize: isSmallerVersion ? 12 : 14,
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
                style: sTextH4Style.copyWith(
                  color: isError
                      ? colors.grey1
                      : isSecandary && !isSmallerVersion
                          ? colors.purple
                          : null,
                  decoration: isError ? TextDecoration.lineThrough : null,
                  fontSize: isSmallerVersion ? 20 : 24,
                ),
              ),
            if (assetBaseAmount != null)
              Text(
                assetBaseAmount!,
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                  height: 1.4,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
