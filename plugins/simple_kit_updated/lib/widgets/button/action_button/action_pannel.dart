import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ActionPannel extends StatelessWidget {
  const ActionPannel({super.key, required this.actionButtons});

  final List<SActionButton> actionButtons;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(actionButtons.length, (index) {
        return Flexible(
          child: Padding(
            padding: EdgeInsets.only(
              left: index != 0 ? 4 : 0,
              right: index < actionButtons.length - 1 ? 4 : 0,
            ),
            child: actionButtons[index],
          ),
        );
      }),
    );
  }
}
