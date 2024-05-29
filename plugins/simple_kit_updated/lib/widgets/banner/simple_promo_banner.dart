import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SPromoBanner extends StatelessWidget {
  const SPromoBanner({
    super.key,
    required this.onCloseBannerTap,
    required this.title,
    this.description,
    required this.promoImage,
    required this.onBannerTap,
    required this.textWidthPercent,
    this.hasCloseButton = true,
  });

  final String? title;
  final String? description;
  final ImageProvider<Object> promoImage;
  final void Function() onCloseBannerTap;
  final void Function() onBannerTap;
  final double textWidthPercent;
  final bool hasCloseButton;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        final bannerWidth = boxConstraints.maxWidth;
        final textWidth = bannerWidth * textWidthPercent;

        return InkWell(
          onTap: onBannerTap,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  image: DecorationImage(
                    image: promoImage,
                    fit: BoxFit.fitWidth,
                  ),
                  color: colors.extraLightsBlue,
                ),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: textWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: AutoSizeText.rich(
                              TextSpan(
                                children: [
                                  if (title != null)
                                    TextSpan(
                                      text: title ?? '',
                                      style: STStyles.body1Bold,
                                    ),
                                  if (description != null && title != null)
                                    TextSpan(
                                      text: '\n',
                                      style: STStyles.body1Medium,
                                    ),
                                  if (description != null)
                                    TextSpan(
                                      text: description ?? '',
                                      style: STStyles.body1Medium,
                                    ),
                                ],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasCloseButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: onCloseBannerTap,
                    child: Assets.svg.medium.closeAlt.simpleSvg(
                      width: 20,
                      color: colors.black,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
