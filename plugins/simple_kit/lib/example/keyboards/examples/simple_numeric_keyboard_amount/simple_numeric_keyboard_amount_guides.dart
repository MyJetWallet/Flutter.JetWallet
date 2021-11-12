import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import '../../../shared.dart';

class SimpleNumericKeyboardAmountGuides extends StatelessWidget {
  const SimpleNumericKeyboardAmountGuides({Key? key}) : super(key: key);

  static const routeName = '/simple_numeric_keyboard_amount_guides';

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Column(
        children: [
          const Spacer(),
          Stack(
            children: [
              SNumericKeyboardAmount(
                preset1Name: '\$50',
                preset2Name: '\$100',
                preset3Name: '\$500',
                selectedPreset: SKeyboardPreset.preset3,
                onPresetChanged: (keyboardPreset) {},
                onKeyPressed: (key) {
                  showSnackBar(context, key);
                },
                submitButtonActive: true,
                submitButtonName: 'Primary',
                onSubmitPressed: () {
                  showSnackBar(context, 'Submit pressed');
                },
              ),
              SizedBox(
                height: 422.h,
                child: Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 422.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          '24px',
                          style: TextStyle(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 24.w,
                      height: 422.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          '24px',
                          style: TextStyle(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 422.h,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('20px'),
                      ),
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 48.h,
                      child: const Text(
                        '48px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      width: 200.w,
                      height: 56.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Text(
                        '56px',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 24.h,
                      child: const Text(
                        '24px',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _ContainerH10 extends StatelessWidget {
  const _ContainerH10({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10.h,
      color: Colors.blue.withOpacity(0.3),
      child: Center(
        child: Text(
          '10px',
          style: TextStyle(
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}
