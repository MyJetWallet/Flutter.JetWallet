import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../state/navigation_stpod.dart';

class BottomNavigationItem extends HookWidget {
  const BottomNavigationItem({
    Key? key,
    required this.index,
    required this.icon,
  }) : super(key: key);

  final int index;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final navigation = useProvider(navigationStpod);

    return Expanded(
      child: InkResponse(
        radius: 50.0,
        onTap: () => navigation.state = index,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
          ),
          child: Icon(
            icon,
            size: 25.0,
            color: navigation.state == index ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}
