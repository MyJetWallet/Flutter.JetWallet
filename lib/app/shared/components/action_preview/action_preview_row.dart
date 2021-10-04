import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../text/asset_conversion_text.dart';

class ActionPreviewRow extends StatelessWidget {
  const ActionPreviewRow({
    Key? key,
    this.loading = false,
    required this.description,
    required this.value,
  }) : super(key: key);

  final bool loading;
  final String description;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AssetConversionText(
              text: description,
              fontSize: 15.sp,
            ),
          ),
          if (loading)
            Container(
              width: 120.w,
              height: 15.h,
              color: Colors.grey[300],
            )
          else
            Expanded(
              flex: 4,
              child: AssetConversionText(
                text: value,
                fontSize: 15.sp,
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }
}
