import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class WithoutRecurringBuysItem extends StatelessObserverWidget {
  const WithoutRecurringBuysItem({
    this.selected = false,
    required this.primaryText,
    required this.onTap,
  });

  final String primaryText;
  final bool selected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      onTap: onTap,
      highlightColor: colors.grey5,
      child: SPaddingH24(
        child: Container(
          alignment: Alignment.centerLeft,
          height: 64,
          child: Text(
            primaryText,
            style: sSubtitle2Style.copyWith(
              color: selected ? colors.blue : colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
