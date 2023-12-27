import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

enum SHeaderSize { s, m, l, xl }

class STableHeader extends StatelessWidget {
  const STableHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.isCenter = false,
    this.size = SHeaderSize.s,
  }) : super(key: key);

  final String title;
  final String? subtitle;

  final SHeaderSize size;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    double getHeightBaseOnSize() {
      switch (size) {
        case SHeaderSize.s:
          return 92;
        case SHeaderSize.m:
          return 96;
        case SHeaderSize.l:
          return 100;
        case SHeaderSize.xl:
          return 112;
        default:
          return 98;
      }
    }

    double getCollapsedHeightBaseOnSize() {
      switch (size) {
        case SHeaderSize.s:
          return 52;
        case SHeaderSize.m:
          return 56;
        case SHeaderSize.l:
          return 60;
        case SHeaderSize.xl:
          return 72;
        default:
          return 98;
      }
    }

    TextStyle getStyleTitleBaseOnSize() {
      switch (size) {
        case SHeaderSize.s:
          return STStyles.header6;
        case SHeaderSize.m:
          return STStyles.header5;
        case SHeaderSize.l:
          return STStyles.header4;
        case SHeaderSize.xl:
          return STStyles.header3;
        default:
          return STStyles.header6;
      }
    }

    TextStyle getStyleSubTitleBaseOnSize() {
      switch (size) {
        case SHeaderSize.s:
          return STStyles.body1Medium;
        case SHeaderSize.m:
          return STStyles.body1Medium;
        case SHeaderSize.l:
          return STStyles.body1Medium;
        case SHeaderSize.xl:
          return STStyles.body1Semibold;
        default:
          return STStyles.header6;
      }
    }

    return SizedBox(
      height: subtitle != null ? getHeightBaseOnSize() : getCollapsedHeightBaseOnSize(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                title,
                style: getStyleTitleBaseOnSize(),
              ),
            ),
            if (subtitle != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  subtitle ?? '',
                  style: getStyleSubTitleBaseOnSize().copyWith(
                    color: SColorsLight().gray10,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
