import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../provider/navigation_stpod.dart';

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
    final navigation = useProvider(navigationStpod);
    final color = navigation.state == index ? Colors.black : Colors.grey;

    return Expanded(
      child: InkResponse(
        radius: 50.r,
        onTap: () => navigation.state = index,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20.w,
                color: color,
              ),
              Text(
                name,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
