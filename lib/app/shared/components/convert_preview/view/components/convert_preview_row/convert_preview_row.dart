import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/convert_preview_row_text.dart';

class ConvertPreviewRow extends StatelessWidget {
  const ConvertPreviewRow({
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConvertPreviewRowText(
            text: description,
          ),
          if (loading)
            Container(
              width: 120.w,
              height: 15.h,
              color: Colors.grey[300],
            )
          else
            ConvertPreviewRowText(
              text: value,
            ),
        ],
      ),
    );
  }
}
