import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/navigation_action/navigation_action.dart';
import '../../../provider/navigation_stpod.dart';

const _navigationAction = 2;

class BottomNavigationItem extends HookWidget {
  const BottomNavigationItem({
    Key? key,
    required this.index,
    required this.icon,
    required this.name,
  }) : super(key: key);

  final int index;
  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final navigation = useProvider(navigationStpod);
    final color = navigation.state == index ? Colors.black : Colors.grey;

    return Expanded(
      child: InkResponse(
        radius: 50.r,
        onTap: () {
          if (index == _navigationAction) {
            showNavigationAction(context, intl);
          } else {
            navigation.state = index;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Icon(
                    icon,
                    size: 18.r,
                    color: color,
                  ),
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
