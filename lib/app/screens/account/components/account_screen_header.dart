import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/spacers.dart';
import '../../../../shared/providers/service_providers.dart';

class AccountScreenHeader extends HookWidget {
  const AccountScreenHeader({
    Key? key,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.account,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          userName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SpaceH4(),
        Text(
          userEmail,
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
      ],
    );
  }
}
