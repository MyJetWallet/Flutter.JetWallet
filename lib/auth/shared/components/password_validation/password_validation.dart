import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../helpers/password_validators.dart';

class PasswordValidation extends StatelessWidget {
  const PasswordValidation({
    Key? key,
    required this.password,
  }) : super(key: key);

  final String password;

  @override
  Widget build(BuildContext context) {
    final case1 = isPasswordLengthValid(password);
    final case2 = isPasswordHasAtLeastOneLetter(password);
    final case3 = isPasswordHasAtLeastOneNumber(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 24.h,
          color: Colors.grey[200],
        ),
        SPasswordRequirement(
          passed: case1,
          description: 'be between 8 to 31 characters',
        ),
        SPasswordRequirement(
          passed: case2,
          description: 'сontain at least one letter (a-z)',
        ),
        SPasswordRequirement(
          passed: case3,
          description: 'contain at least one number (0-9)',
        ),
      ],
    );
  }
}
