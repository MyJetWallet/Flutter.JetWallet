import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SimpleAccountTermButton extends StatelessWidget {
  const SimpleAccountTermButton({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.w,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          name,
          style: sBodyText2Style,
        ),
      ),
    );
  }
}
