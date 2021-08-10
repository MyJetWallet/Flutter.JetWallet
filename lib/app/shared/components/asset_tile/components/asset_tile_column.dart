import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../shared/components/spacers.dart';

class AssetTileColumn extends StatelessWidget {
  const AssetTileColumn({
    Key? key,
    required this.headerColor,
    required this.subheaderColor,
    required this.header,
    required this.subheader,
    required this.crossAxisAlignment,
  }) : super(key: key);

  final Color headerColor;
  final Color subheaderColor;
  final String header;
  final String subheader;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          header,
          style: TextStyle(
            fontSize: 16.sp,
            color: headerColor,
          ),
        ),
        const SpaceH2(),
        Text(
          subheader,
          style: TextStyle(
            fontSize: 12.sp,
            color: subheaderColor,
          ),
        ),
      ],
    );
  }
}
