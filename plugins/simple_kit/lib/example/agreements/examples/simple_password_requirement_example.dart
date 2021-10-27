import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimplePasswordRequirementExample extends StatelessWidget {
  const SimplePasswordRequirementExample({Key? key}) : super(key: key);

  static const routeName = '/simple_password_requirement_example';

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SPasswordRequirement(
              passed: true,
              description: 'be between 8 to 31 characters',
            ),
            const SPasswordRequirement(
              passed: false,
              description: 'be between 8 to 31 characters',
            ),
            const SpaceH10(),
            Stack(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: const SPasswordRequirement(
                    passed: false,
                    description: 'be between 8 to 31 characters',
                  ),
                ),
                Container(
                  color: Colors.green.withOpacity(0.3),
                  height: 17.h,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
