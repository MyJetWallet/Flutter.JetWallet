import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../../shared/components/spacers.dart';

class AssetField extends StatelessWidget {
  const AssetField({
    Key? key,
    required this.onTap,
    required this.value,
    required this.enabled,
  }) : super(key: key);

  final Function() onTap;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.40.sw,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                value.isEmpty ? 'min 0.001' : value,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: value.isEmpty
                      ? Colors.grey
                      : enabled
                          ? Colors.black87
                          : Colors.grey,
                  fontWeight:
                      value.isEmpty ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            const SpaceH10(),
            Container(
              height: 1.5.h,
              width: 0.40.sw,
              color: enabled ? Colors.black : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
