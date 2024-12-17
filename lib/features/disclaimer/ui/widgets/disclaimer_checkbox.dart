import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/disclaimer/store/disclaimer_store.dart';
import 'package:simple_kit/simple_kit.dart';

class DisclaimerCheckbox extends StatelessObserverWidget {
  const DisclaimerCheckbox({
    super.key,
    this.indexCheckBox,
    required this.questions,
    required this.firstText,
    required this.onCheckboxTap,
  });

  final int? indexCheckBox;
  final String firstText;
  final Flexible questions;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    final state = getIt.get<DisclaimerStore>();

    if (indexCheckBox != null) {
      icon = state.questions[indexCheckBox!].defaultState ? const SCheckboxSelectedIcon() : const SCheckboxIcon();
    }

    return Container(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeGesture(
            onTap: onCheckboxTap,
            child: icon,
          ),
          const SpaceW10(),
          questions,
        ],
      ),
    );
  }
}
