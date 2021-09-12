import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/withdrawal_suffix_icon.dart';

class WithdrawalFieldSuffix extends StatelessWidget {
  const WithdrawalFieldSuffix({
    Key? key,
    required this.onErase,
    required this.onPaste,
    required this.onScanQr,
    required this.showErase,
    required this.showEmptyField,
  }) : super(key: key);

  final Function() onErase;
  final Function() onPaste;
  final Function() onScanQr;
  final bool showErase;
  final bool showEmptyField;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: showErase ? 30.w : 60.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showErase)
            WithdrawalSuffixIcon(
              icon: Icons.highlight_off,
              onTap: onErase,
            )
          else if (showEmptyField)
            const SizedBox()
          else ...[
            WithdrawalSuffixIcon(
              icon: Icons.content_paste,
              onTap: onPaste,
            ),
            WithdrawalSuffixIcon(
              icon: Icons.qr_code,
              onTap: onScanQr,
            ),
          ]
        ],
      ),
    );
  }
}
