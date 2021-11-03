import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import '../../../src/action_sheet/components/simple_action_sheet_item.dart';

class SimpleActionSheetItemExample extends StatelessWidget {
  const SimpleActionSheetItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_sheet_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: const SActionSheetItem(),
                  ),
                  Row(
                    children: [
                      const SActionBuyIcon(),
                      Container(
                        color: Colors.blue.withOpacity(0.3),
                        width: 10.w,
                        height: 64.h,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        color: Colors.blue.withOpacity(0.3),
                        width: double.infinity,
                        height: 10.h,
                      ),
                    ],
                  ),
                ],
              ),
              const SpaceH20(),
              const SActionSheetItem()
            ],
          ),
        ),
      ),
    );
  }
}
