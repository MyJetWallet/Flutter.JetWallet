import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SuggestionButton extends StatelessWidget {
  const SuggestionButton({
    super.key,
    required this.icon,
    this.title,
    required this.subTitle,
    this.trailing,
    required this.onTap,
    this.isDisabled = false,
    this.showArrow = true,
  });

  final Widget icon;
  final String? title;
  final String subTitle;
  final String? trailing;
  final void Function() onTap;
  final bool isDisabled;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final greyDisabled = SColorsLight().gray8;

    return Container(
      height: 56,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 24),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: colors.gray2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: !isDisabled ? onTap : null,
        child: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  icon,
                  const SpaceW8(),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subTitle,
                          style: STStyles.body2Medium.copyWith(
                            color: isDisabled ? greyDisabled : colors.gray10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (title != null)
                          Text(
                            title!,
                            style: STStyles.body2Medium.copyWith(
                              color: isDisabled ? greyDisabled : colors.black,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  trailing ?? '',
                  textAlign: TextAlign.right,
                  style: STStyles.body2Medium.copyWith(
                    color: isDisabled ? greyDisabled : colors.gray10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (showArrow) ...[
                  const SpaceW8(),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Assets.svg.medium.blueRightArrow.simpleSvg(
                      color: isDisabled ? greyDisabled : colors.black,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
