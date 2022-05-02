import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class WithOutRecurringBuysItem extends HookWidget {
  const WithOutRecurringBuysItem({
    Key? key,
    this.selected = false,
    required this.primaryText,
    required this.onTap,
  }) : super(key: key);

  final String primaryText;
  final bool selected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

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
