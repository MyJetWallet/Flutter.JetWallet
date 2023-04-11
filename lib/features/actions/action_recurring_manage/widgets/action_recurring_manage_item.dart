import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionRecurringManageItem extends StatelessWidget {
  const ActionRecurringManageItem({
    required this.primaryText,
    required this.onTap,
    required this.icon,
    required this.color,
  });

  final String primaryText;
  final Function() onTap;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: color,
      hoverColor: Colors.transparent,
      child: SPaddingH24(
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 64,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: icon,
              ),
              Text(
                primaryText,
                style: sSubtitle2Style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
