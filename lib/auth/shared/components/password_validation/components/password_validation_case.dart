import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/components/spacers.dart';

class PasswordValidationCase extends StatelessWidget {
  const PasswordValidationCase({
    Key? key,
    this.finalCase = false,
    required this.casePassed,
    required this.description,
  }) : super(key: key);

  final bool finalCase;
  final bool casePassed;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpaceH10(),
        Row(
          children: [
            if (casePassed)
              Icon(
                FontAwesomeIcons.check,
                size: 12.r,
                color: Colors.grey,
              )
            else
              Container(
                width: 5.w,
                height: 5.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
            const SpaceW10(),
            Text(
              description,
              style: TextStyle(
                color: finalCase ? Colors.black54 : Colors.grey,
                fontWeight: finalCase ? FontWeight.bold : FontWeight.normal,
                decoration: finalCase
                    ? null
                    : casePassed
                        ? TextDecoration.lineThrough
                        : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
