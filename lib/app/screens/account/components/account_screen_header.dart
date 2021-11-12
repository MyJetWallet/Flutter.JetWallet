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

    return Container(
      padding: EdgeInsets.only(
        top: 52.h,
        bottom: 20.h,
      ),
      height: 120.h,
      child: SPaddingH24(
        child: Row(
          children: <Widget>[
            Container(
              height: 48.h,
              width: 48.h,
              decoration: BoxDecoration(
                color: colors.red,
                borderRadius: BorderRadius.circular(44.r),
              ),
            ),
            const SpaceW20(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Todo: change 'Jonh Shooter' on username from provider
                  Text(
                    'John Shooter',
                    style: sTextH5Style,
                  ),
                  const SpaceH2(),
                  Text(
                    userEmail,
                    style: sSubtitle3Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
