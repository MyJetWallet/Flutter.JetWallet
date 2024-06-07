import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class AccountButtonWidget extends StatelessWidget {
  const AccountButtonWidget({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
  });

  final Widget icon;
  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeGesture(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: [
            icon,
            const SpaceW12(),
            Expanded(
              child: Baseline(
                baseline: 20,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  title,
                  style: sSubtitle2Style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
