import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../../shared/components/spacers.dart';

class DepositField extends HookWidget {
  const DepositField({
    Key? key,
    this.actualValue,
    required this.open,
    required this.onTap,
    required this.header,
    required this.text,
  }) : super(key: key);

  final String? actualValue;
  final bool open;
  final Function() onTap;
  final String header;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          if (open) ...[
            const SpaceH10(),
            Text(
              header,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SpaceH10(),
            QrImage(
              padding: EdgeInsets.zero,
              data: actualValue ?? text,
              size: 150.r,
            ),
            const SpaceH10(),
          ],
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: open ? Colors.grey[100] : null,
                borderRadius: open
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      )
                    : BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        header,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                      const SpaceH8(),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (!open)
                    Icon(
                      Icons.qr_code,
                      size: 18.r,
                    ),
                  const SpaceW10(),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: actualValue ?? text,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.copy,
                      size: 18.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
