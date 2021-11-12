import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleActionConfirmTextExample extends StatelessWidget {
  const SimpleActionConfirmTextExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_confirm_text_example';

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
                    child: const SActionConfirmText(
                      name: 'You will get really long text about this '
                          'transaction, go more text, I need more text '
                          'You will get really long text about this ',
                      value: '≈ 0,0192455 BTC',
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 40.h,
                    color: Colors.red.withOpacity(0.2),
                    child: const Text('40px'),
                  )
                ],
              ),
              const SpaceH20(),
              Stack(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: const SActionConfirmText(
                      name: 'You will get really long text '
                          'about go to this just more',
                      value: '≈ 0,0192455 BTC',
                    ),
                  ),
                  const _ValueWidthTester()
                ],
              ),
              const SpaceH20(),
              Stack(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: const SActionConfirmText(
                      name: 'You will get really long text '
                          'about go to this just more',
                      value: '≈ 0,019245',
                    ),
                  ),
                  const _ValueWidthTester()
                ],
              ),
              const SpaceH20(),
              Stack(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: const SActionConfirmText(
                      name: 'You will get really long text '
                          'about go to this just more',
                      value: '≈ 0,0192455 BTC we have long',
                    ),
                  ),
                  const _ValueWidthTester()
                ],
              ),
              const SActionConfirmText(
                name: 'You will get',
                value: '≈ 0,0192455 BTC',
              ),
              SActionConfirmText(
                name: 'You will pay',
                value: '\$500,00',
                valueColor: SColorsLight().blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueWidthTester extends StatelessWidget {
  const _ValueWidthTester({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Container(
          width: 10.w,
          height: 40.h,
          color: Colors.red.withOpacity(0.2),
        ),
        Container(
          width: 80.w,
          height: 40.h,
          color: Colors.blue.withOpacity(0.2),
          child: const Text('80px'),
        ),
        Container(
          width: 100.w,
          height: 40.h,
          color: Colors.green.withOpacity(0.2),
          child: const Text('100px'),
        ),
      ],
    );
  }
}
