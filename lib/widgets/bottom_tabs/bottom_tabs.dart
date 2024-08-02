import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomTabs extends StatelessObserverWidget {
  const BottomTabs({
    super.key,
    this.tabController,
    this.bottomPadding = 0,
    required this.tabs,
  });

  final TabController? tabController;
  final List<Widget> tabs;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return tabs.isEmpty
        ? const SizedBox()
        : Container(
            color: colors.white.withOpacity(0.4),
            height: 56 + bottomPadding,
            width: double.infinity,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(
                    color: colors.grey5,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    border: Border.all(
                      width: 2,
                      color: colors.black,
                    ),
                  ),
                  indicatorPadding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                  labelPadding: EdgeInsets.zero,
                  labelColor: colors.black,
                  labelStyle: sBodyText1Style,
                  unselectedLabelColor: colors.grey1,
                  unselectedLabelStyle: sBodyText1Style,
                  isScrollable: true,
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 14,
                    bottom: bottomPadding,
                  ),
                  tabs: tabs,
                ),
              ),
            ),
          );
  }
}
