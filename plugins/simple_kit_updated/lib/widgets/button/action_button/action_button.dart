import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import 'package:flutter/material.dart';

enum ActionButtonType { primary, secondary }

enum ActionButtonState { defaylt, disabled, skeleton }

class SActionButton extends HookWidget {
  const SActionButton({
    super.key,
    this.onTap,
    this.lable,
    required this.icon,
    this.type = ActionButtonType.primary,
    this.state = ActionButtonState.defaylt,
  });

  final Function()? onTap;
  final Widget icon;
  final String? lable;
  final ActionButtonType type;
  final ActionButtonState state;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: () {
        onTap!();
      },
      onHighlightChanged: (value) {
        isHighlated.value = value;
      },
      child: Column(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state == ActionButtonState.disabled
                  ? SColorsLight().grayAlfa
                  : isHighlated.value
                      ? SColorsLight().gray10
                      : SColorsLight().black,
            ),
            padding: const EdgeInsets.all(12),
            child: Center(
              child: icon,
            ),
          ),
          if (lable != null) ...[
            const SizedBox(height: 12),
            Text(
              lable ?? '',
              style: STStyles.captionSemibold,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
