import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';
import '../shared/components/simple_icon_button.dart';

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
      constraints: BoxConstraints(
        minHeight: 180.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 64.h,
          ),
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
            baseline: 56.h,
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
