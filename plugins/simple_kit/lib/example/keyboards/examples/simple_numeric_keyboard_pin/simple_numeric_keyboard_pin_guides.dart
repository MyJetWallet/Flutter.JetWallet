import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SimpleNumericKeyboardPinGuides extends StatelessWidget {
  const SimpleNumericKeyboardPinGuides({Key? key}) : super(key: key);

  static const routeName = '/simple_numeric_keyboard_pin_guides';

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Column(
        children: [
          const Spacer(),
          Stack(
            children: [
              SNumericKeyboardPin(
                onKeyPressed: (value) {},
              ),
              SizedBox(
                height: 354.h,
                child: Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 354.h,
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
                      height: 354.h,
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
                height: 354.h,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('40px'),
                      ),
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
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
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
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
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
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
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.h,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('60px'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
