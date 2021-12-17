import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SMegaHeader extends StatelessWidget {
  const SMegaHeader({
    Key? key,
    this.onBackButtonTap,
    this.titleAlign = TextAlign.center,
    required this.title,
  }) : super(key: key);

  final Function()? onBackButtonTap;
  final TextAlign titleAlign;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 180.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
          Row(
            children: [
              SIconButton(
                onTap: onBackButtonTap ?? () => Navigator.pop(context),
                defaultIcon: const SBackIcon(),
                pressedIcon: const SBackPressedIcon(),
              ),
            ],
          ),
          Baseline(
            baseline: 56.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              title,
              textAlign: titleAlign,
              maxLines: 3,
              style: sTextH2Style,
            ),
          ),
        ],
      ),
    );
  }
}
