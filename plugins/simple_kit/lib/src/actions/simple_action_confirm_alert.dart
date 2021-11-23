import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

const _defaultAlert = 'Connecting to server… Please wait or try again later';

class SActionConfirmAlert extends StatelessWidget {
  const SActionConfirmAlert({
    Key? key,
    this.alert,
  }) : super(key: key);

  final String? alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.w,
          color: SColorsLight().grey4,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(20.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SErrorIcon(
            color: SColorsLight().red,
          ),
          const SpaceW10(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH2(),
                Text(
                  alert ?? _defaultAlert,
                  maxLines: 2,
                  style: sBodyText1Style,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
