import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionRecurringManageItem extends StatelessWidget {
  const ActionRecurringManageItem({
    Key? key,
    required this.primaryText,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final String primaryText;
  final Function() onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    log('$icon');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
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
    );
  }
}
