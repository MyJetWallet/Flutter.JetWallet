import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../simple_kit.dart';
import '../../../src/colors/view/simple_colors_light.dart';

class SimpleActionConfirmTextExample extends HookWidget {
  const SimpleActionConfirmTextExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_confirm_text_example';

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController();

    return Scaffold(
      body: Center(
        child: SPaddingH24(
          child: ListView(
            children: [
              const SpaceH20(),
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
                    height: 40.0,
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
              const SpaceH20(),
              Stack(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: const SActionConfirmText(
                      contentLoading: true,
                      name: 'You will get really long text '
                          'about go to this just more',
                      value: '≈ 0,0192455 BTC we have long',
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
                    child: SActionConfirmText(
                      animation: controller,
                      name: 'You will get really long text '
                          'about go to this just more',
                      value: '1 USD ≈ 0,0003431 BTC',
                    ),
                  ),
                  const _ValueWidthTesterForTimer()
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
              SActionConfirmText(
                name: 'You will pay',
                value: '\$500,00',
                contentLoading: true,
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
          width: 10.0,
          height: 40.0,
          color: Colors.red.withOpacity(0.1),
        ),
        Container(
          width: 80.0,
          height: 40.0,
          color: Colors.blue.withOpacity(0.1),
          child: const Text('80px'),
        ),
        Container(
          width: 100.0,
          height: 40.0,
          color: Colors.green.withOpacity(0.1),
          child: const Text('100px'),
        ),
      ],
    );
  }
}

class _ValueWidthTesterForTimer extends StatelessWidget {
  const _ValueWidthTesterForTimer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Container(
          width: 10.0,
          height: 40.0,
          color: Colors.red.withOpacity(0.1),
        ),
        Container(
          width: 100.0,
          height: 40.0,
          color: Colors.blue.withOpacity(0.1),
          child: const Text('100px'),
        ),
        Column(
          children: [
            Container(
              width: 100.0,
              height: 40.0,
              color: Colors.green.withOpacity(0.1),
              child: const Text('100px'),
            ),
            Container(
              width: 100.0,
              height: 3.0,
              color: Colors.red.withOpacity(0.1),
              child: const Text('100px'),
            ),
          ],
        ),
      ],
    );
  }
}
