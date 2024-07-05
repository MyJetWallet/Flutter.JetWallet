import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum TransactionCellSize { large, small }

enum TransactionCellType { def, failed, loading }

class TransactionCellAsset {
  TransactionCellAsset({
    required this.icon,
    required this.title,
    required this.value,
    this.supplementText,
    this.haveSupplement = false,
  });

  final Widget icon;
  final String title;
  final String value;
  final String? supplementText;

  final bool haveSupplement;
}

class TransactionCell extends StatelessWidget {
  const TransactionCell({
    super.key,
    this.size = TransactionCellSize.large,
    this.type = TransactionCellType.def,
    required this.assetOne,
    this.asssetTwo,
  });

  final TransactionCellSize size;
  final TransactionCellType type;

  final TransactionCellAsset assetOne;
  final TransactionCellAsset? asssetTwo;

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      switch (size) {
        case TransactionCellSize.large:
          return asssetTwo != null ? 184 : 120;
        case TransactionCellSize.small:
          return asssetTwo != null ? 112 : 60;
      }
    }

    TextStyle getTitleTextStyle() {
      switch (size) {
        case TransactionCellSize.large:
          return STStyles.body2Semibold;
        case TransactionCellSize.small:
          return STStyles.captionSemibold;
      }
    }

    TextStyle getValueTextStyle() {
      switch (size) {
        case TransactionCellSize.large:
          return STStyles.header5;
        case TransactionCellSize.small:
          return STStyles.header6;
      }
    }

    TextStyle getSupplementTextStyle() {
      switch (size) {
        case TransactionCellSize.large:
          return STStyles.body2Semibold;
        case TransactionCellSize.small:
          return STStyles.captionSemibold;
      }
    }

    Widget assetCell(TransactionCellAsset asset) {
      return SizedBox(
        height: size == TransactionCellSize.large
            ? asset.haveSupplement
                ? 72
                : 52
            : asset.haveSupplement
                ? 60
                : 44,
        child: Row(
          children: [
            SizedBox(
              width: size == TransactionCellSize.large ? 40 : 32,
              height: size == TransactionCellSize.large ? 40 : 32,
              child: asset.icon,
            ),
            const Gap(12),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.title,
                  style: getTitleTextStyle().copyWith(
                    color: SColorsLight().gray10,
                  ),
                ),
                if (type == TransactionCellType.loading) ...[
                  Container(
                    width: 120,
                    height: size == TransactionCellSize.large ? 32 : 28,
                    decoration: ShapeDecoration(
                      color: SColorsLight().gray4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ] else ...[
                  Text(
                    asset.value,
                    style: getValueTextStyle().copyWith(
                      decoration: type == TransactionCellType.failed ? TextDecoration.lineThrough : null,
                      color: type == TransactionCellType.failed ? SColorsLight().gray10 : SColorsLight().black,
                    ),
                  ),
                  if (asset.haveSupplement)
                    Text(
                      asset.supplementText ?? '',
                      style: getSupplementTextStyle().copyWith(
                        color: SColorsLight().gray10,
                      ),
                    ),
                ],
              ],
            ),
          ],
        ),
      );
    }

    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        height: getHeight(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: size == TransactionCellSize.large ? 24 : 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              assetCell(assetOne),
              if (asssetTwo != null) ...[
                SizedBox(
                  height: size == TransactionCellSize.large ? 32 : 24,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size == TransactionCellSize.large ? 12 : 8,
                      vertical: size == TransactionCellSize.large ? 8 : 4,
                    ),
                    child: type == TransactionCellType.failed
                        ? Assets.svg.medium.close.simpleSvg(
                            width: 16,
                            height: 16,
                            color: SColorsLight().gray8,
                          )
                        : Assets.svg.medium.chevronDownDouble.simpleSvg(
                            width: 16,
                            height: 16,
                            color: SColorsLight().gray8,
                          ),
                  ),
                ),
                assetCell(asssetTwo!),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
