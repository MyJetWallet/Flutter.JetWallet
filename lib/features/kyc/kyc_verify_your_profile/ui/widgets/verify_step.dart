import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class VerificationSteep extends StatelessWidget {
  const VerificationSteep({
    required this.lable,
    this.isDone = false,
    this.isDisabled = false,
    this.subtext,
  });

  final String lable;
  final String? subtext;
  final bool isDone;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: isDisabled
                ? Assets.svg.small.minusCircle.simpleSvg(
                    color: colors.black,
                  )
                : (!isDone)
                    ? Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.only(left: 2),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.black,
                        ),
                      )
                    : Assets.svg.small.checkCircle.simpleSvg(
                        color: colors.blue,
                      ),
          ),
          const SpaceW16(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lable,
                style: STStyles.subtitle1.copyWith(
                  color: isDone ? colors.blue : colors.black,
                ),
              ),
              if (subtext != null) ...[
                const SpaceH4(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    subtext ?? '',
                    maxLines: 2,
                    style: STStyles.body2Medium.copyWith(
                      color: colors.gray10,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
