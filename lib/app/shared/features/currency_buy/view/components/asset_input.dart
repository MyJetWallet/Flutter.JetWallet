import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/spacers.dart';

class AssetInput extends StatelessWidget {
  const AssetInput({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: 46.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SpaceH10(),
        Container(
          height: 1.5.h,
          width: double.infinity,
          color: Colors.black,
        )
      ],
    );
  }
}
