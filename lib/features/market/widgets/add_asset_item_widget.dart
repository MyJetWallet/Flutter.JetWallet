import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class AddAssetItemWidget extends StatelessWidget {
  const AddAssetItemWidget({
    super.key,
    required this.iconUrl,
    required this.assetDescription,
    required this.assetSymbol,
    required this.isFavourite,
    required this.onSave,
  });

  final String iconUrl;
  final String assetDescription;
  final String assetSymbol;
  final bool isFavourite;
  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          NetworkIconWidget(
            iconUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              assetDescription,
              style: STStyles.subtitle1,
            ),
          ),
          Text(
            assetSymbol,
            style: STStyles.subtitle2.copyWith(
              color: colors.gray10,
            ),
          ),
          const SizedBox(width: 16),
          SafeGesture(
            onTap: onSave,
            child: isFavourite
                ? Assets.svg.medium.favourite2.simpleSvg(
                    width: 24,
                  )
                : Assets.svg.medium.favourite.simpleSvg(
                    width: 24,
                  ),
          ),
        ],
      ),
    );
  }
}
