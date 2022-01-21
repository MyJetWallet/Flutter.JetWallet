import 'package:flutter/material.dart';

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
              Column(
                children: [
                  const SpaceH20(),
                  Container(
                    width: 100.0,
                    height: 29.0,
                    color: Colors.red.withOpacity(0.3),
                    child: const Center(
                      child: Text(
                        '29px',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 422.0,
                child: Row(
                  children: [
                    Container(
                      width: 24.0,
                      height: 422.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text(
                          '24px',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 24.0,
                      height: 422.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text(
                          '24px',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 422.0,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('20px'),
                      ),
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 48.0,
                      child: const Text(
                        '48px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    const _ContainerH10(),
                    Container(
                      width: 200.0,
                      height: 56.0,
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
                      height: 24.0,
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
      height: 10.0,
      color: Colors.blue.withOpacity(0.3),
      child: const Center(
        child: Text(
          '10px',
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}
