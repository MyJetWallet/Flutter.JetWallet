import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class PortfolioWithBalanceHeader extends HookWidget {
  const PortfolioWithBalanceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SizedBox(
      height: 120.h,
      child: Column(
        children: [
          const SpaceH64(),
          Row(
            children: [
              const SpaceW24(),
              Text(
                'Balance',
                style: sTextH5Style,
              ),
              const Spacer(),
              Container(
                width: 77.h,
                height: 28.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  color: colors.green,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 10.w,
                  ),
                  child: Row(
                    children: [
                      const SGiftPortfolioIcon(),
                      const SpaceW8(),
                      Text(
                        '\$15',
                        style: sSubtitle3Style.copyWith(color: colors.white),
                      )
                    ],
                  ),
                ),
              ),
              const SpaceW24(),
            ],
          ),
        ],
      ),
    );
  }
}
