import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleActionItemExample extends StatelessWidget {
  const SimpleActionItemExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_item_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: SActionItem(
                    onTap: () {},
                    icon: const SActionBuyIcon(),
                    name: 'Operation Name',
                    helperText: 'Fee 3.5%',
                    description: 'Description',
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceW24(),
                    Column(
                      children: [
                        const SpaceH10(),
                        Container(
                          height: 24.h,
                          color: Colors.red[100]!.withOpacity(0.6),
                          child: const SpaceW24(),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.blue.withOpacity(0.3),
                      width: 10.w,
                      height: 64.h,
                      child: Center(
                        child: Text(
                          '10px',
                          style: TextStyle(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.blue.withOpacity(0.3),
                            width: double.infinity,
                            height: 10.h,
                            child: Center(
                              child: Text(
                                '10px',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.green.withOpacity(0.3),
                            width: 293.w,
                            height: 18.h,
                            child: const Center(
                              child: Text(
                                '18px',
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.purple.withOpacity(0.3),
                            width: 293.w,
                            height: 20.h,
                            child: const Center(
                              child: Text(
                                '20px',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceW24(),
                  ],
                ),
              ],
            ),
            const SpaceH20(),
            SActionItem(
              onTap: () {},
              icon: const SActionBuyIcon(),
              name: 'Operation Name',
              helperText: 'Fee 3.5%',
              description: 'Description',
            )
          ],
        ),
      ),
    );
  }
}
