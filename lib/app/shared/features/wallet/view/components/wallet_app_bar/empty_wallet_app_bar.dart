import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/header_text.dart';
import '../../../../../../../shared/components/page_frame/components/frame_action_button.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../helpers/format_currency_string_amount.dart';
import '../../../../../providers/base_currency_pod/base_currency_pod.dart';


class EmptyWalletAppBar extends HookWidget
    implements PreferredSizeWidget {
  const EmptyWalletAppBar({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          Row(
            children: [
              FrameActionButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: HeaderText(
                  text: '$assetName wallet',
                  textAlign: TextAlign.center,
                ),
              ),
              const SpaceW32(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h, bottom: 52.h),
            child: Text(
              formatCurrencyStringAmount(
                value: '0',
                symbol: baseCurrency.symbol,
                prefix: baseCurrency.prefix,
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 42.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(0.25.sh);
}
