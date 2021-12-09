import 'package:flutter/material.dart';

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
                height: 354.0,
                child: Row(
                  children: [
                    Container(
                      width: 24.0,
                      height: 354.0,
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
                      height: 354.0,
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
                height: 354.0,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      color: Colors.blue.withOpacity(0.3),
                      child: const Center(
                        child: Text('40px'),
                      ),
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
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
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
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
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
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
                    ),
                    Container(
                      color: Colors.green.withOpacity(0.3),
                      height: 56.0,
                      child: const Text(
                        '56px',
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60.0,
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
