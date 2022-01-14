import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomTabs extends HookWidget {
  const BottomTabs({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 56,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: TabBar(
            indicator: BoxDecoration(
              color: colors.grey5,
              borderRadius: const BorderRadius.all(
                Radius.circular(24),
              ),
              border: Border.all(
                width: 2,
                color: colors.black,
              ),
            ),
            indicatorPadding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 10,
            ),
            labelPadding: EdgeInsets.zero,
            labelColor: colors.black,
            labelStyle: sBodyText1Style,
            unselectedLabelColor: colors.grey1,
            unselectedLabelStyle: sBodyText1Style,
            isScrollable: true,
            padding: const EdgeInsets.only(
              left: 24,
              right: 14,
            ),
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
