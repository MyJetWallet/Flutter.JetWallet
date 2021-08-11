import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../shared/components/spacers.dart';

class QuoteErrorText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
          size: 18.r,
        ),
        const SpaceW8(),
        Expanded(
          child: Text(
            'Connecting to server... Please wait or try again later',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
