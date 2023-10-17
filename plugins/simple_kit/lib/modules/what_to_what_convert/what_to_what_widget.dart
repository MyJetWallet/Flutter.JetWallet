import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/24x24/public/chevron_down_double/simple_chevron_down_double_icon.dart';
import 'package:simple_kit/simple_kit.dart';

class WhatToWhatConvertWidget extends StatelessWidget {
  const WhatToWhatConvertWidget({
    super.key,
    required this.fromAssetIconUrl,
    required this.fromAssetDescription,
    required this.fromAssetValue,
    required this.toAssetIconUrl,
    required this.toAssetDescription,
    required this.toAssetValue,
  });

  final String fromAssetIconUrl;
  final String fromAssetDescription;
  final String fromAssetValue;
  final String toAssetIconUrl;
  final String toAssetDescription;
  final String toAssetValue;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AssetRowWidget(
            assetIconUrl: fromAssetIconUrl,
            assetDescription: fromAssetDescription,
            assetValue: fromAssetValue,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            width: 16,
            height: 16,
            child: SChevronDownDoubleIcon(
              color: colors.grey2,
            ),
          ),
          _AssetRowWidget(
            assetIconUrl: toAssetIconUrl,
            assetDescription: toAssetDescription,
            assetValue: toAssetValue,
            isSecandary: true,
          ),
        ],
      ),
    );
  }
}

class _AssetRowWidget extends StatelessWidget {
  const _AssetRowWidget({
    required this.assetIconUrl,
    required this.assetDescription,
    required this.assetValue,
    this.isSecandary = false,
  });

  final String assetIconUrl;
  final String assetDescription;
  final String assetValue;
  final bool isSecandary;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        SNetworkSvg(
          url: assetIconUrl,
          width: 40,
          height: 40,
        ),
        const SpaceW12(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assetDescription,
              style: sBodyText2Style.copyWith(
                color: colors.grey1,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              assetValue,
              style: sTextH4Style.copyWith(
                color: isSecandary ? colors.purple : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
