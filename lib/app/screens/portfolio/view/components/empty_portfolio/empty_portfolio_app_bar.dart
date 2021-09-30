import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/header_text.dart';
import '../../../../../shared/helpers/format_currency_string_amount.dart';
import '../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';

class EmptyPortfolioAppBar extends HookWidget implements PreferredSizeWidget {
  const EmptyPortfolioAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          const Expanded(
            child: HeaderText(
              text: 'Balance',
              textAlign: TextAlign.center,
            ),
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
