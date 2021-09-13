import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/components/buttons/app_buton_white.dart';
import '../../../market_details/view/components/balance_block/components/balance_frame.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BalanceFrame(
      backgroundColor: Colors.grey.shade200,
      height: 104.h,
      child: AppButtonWhite(
        name: 'Action',
        onTap: () {
          // TODO(any): Add action bottom sheet
        },
      ),
    );
  }
}
