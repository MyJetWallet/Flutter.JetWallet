import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/table/interactive/simple_interactive_table_base.dart';

enum SimpleHistoryTableType {
  decline,
  completed,
  inProgress,
}

class SimpleHistoryTable extends HookWidget {
  const SimpleHistoryTable({
    super.key,
    required this.label,
    this.icon,
    this.value,
    this.supplement,
    this.onTap,
    this.labelIcon,
    this.rightSupplement,
    this.type,
  });

  final String label;
  final Widget? icon;
  final String? value;
  final String? supplement;
  final VoidCallback? onTap;
  final SvgGenImage? labelIcon;
  final String? rightSupplement;
  final SimpleHistoryTableType? type;

  @override
  Widget build(BuildContext context) {
    Color? mainColor;
    Color? supplementColor;

    if (type != SimpleHistoryTableType.decline) {
      mainColor = SColorsLight().black;
      supplementColor = SColorsLight().gray10;
    } else {
      mainColor = SColorsLight().gray8;
      supplementColor = SColorsLight().gray8;
    }

    final isHighlighted = useState(false);

    return SafeGesture(
      onTap: onTap,
      highlightColor: SColorsLight().gray2,
      onHighlightChanged: (p0) {
        isHighlighted.value = p0;
      },
      child: SAccountTableBase(
        isHighlighted: isHighlighted.value,
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(
                  width: 12.0,
                ),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: STStyles.subtitle1.copyWith(
                                color: mainColor,
                              ),
                            ),
                          ),
                          if (labelIcon != null) ...[
                            const SizedBox(
                              width: 4.0,
                            ),
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: labelIcon!.simpleSvg(
                                color: SColorsLight().gray8,
                              ),
                            ),
                          ],
                          if (value != null) ...[
                            const SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              value!,
                              style: STStyles.subtitle1.copyWith(
                                color: mainColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: supplement != null
                                ? Text(
                                    supplement!,
                                    style: STStyles.body2Medium.copyWith(
                                      color: supplementColor,
                                    ),
                                  )
                                : const SizedBox.expand(),
                          ),
                          if (rightSupplement != null) ...[
                            const SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              rightSupplement!,
                              style: STStyles.body2Medium.copyWith(
                                color: supplementColor,
                              ),
                            ),
                          ],
                          if (type != null) ...[
                            const SizedBox(
                              width: 16.0,
                            ),
                            _buildRightTypeButtonWidget(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightTypeButtonWidget() {
    switch (type) {
      case null:
        return SizedBox();
      case SimpleHistoryTableType.decline:
        return Assets.svg.small.xCricle.simpleSvg(
          height: 20.0,
          width: 20.0,
          color: SColorsLight().gray8,
        );
      case SimpleHistoryTableType.completed:
        return Assets.svg.small.checkCircle.simpleSvg(
          height: 20.0,
          width: 20.0,
          color: SColorsLight().black,
        );
      case SimpleHistoryTableType.inProgress:
        return SizedBox(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(
            color: SColorsLight().gray10,
            strokeWidth: 1,
          ),
        );
    }
  }
}
