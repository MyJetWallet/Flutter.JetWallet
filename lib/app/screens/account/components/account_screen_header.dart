import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountScreenHeader extends HookWidget {
  const AccountScreenHeader({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  final String userEmail;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(44.r),
            ),
          ),
          const SpaceW20(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Todo: change 'Jonh Shooter' on username from provider
                Text(
                  'Jonh Shooter Jonh Shooter Jonh Shooter Jonh Shooter',
                  style: sTextH5Style.copyWith(color: colors.black),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpaceH2(),
                Text(
                  userEmail,
                  style: sSubtitle3Style.copyWith(color: colors.grey1),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
