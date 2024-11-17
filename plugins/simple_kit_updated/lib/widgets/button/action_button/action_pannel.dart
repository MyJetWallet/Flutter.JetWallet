import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ActionPannel extends StatelessWidget {
  const ActionPannel({super.key, required this.actionButtons});

  final List<SActionButton> actionButtons;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(actionButtons.length, (index) {
        return actionButtons[index];
      }),
    );
  }
}
