import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/advanced_app_bar/advanced_app_bar_base.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_large_alt_appbar.dart';

class MainScreenAppbar extends StatelessWidget {
  const MainScreenAppbar({
    Key? key,
    this.showIcon = true,
    required this.child,
    required this.headerTitle,
    this.headerValue,
  }) : super(key: key);

  final bool showIcon;
  final Widget child;

  final String headerTitle;
  final String? headerValue;

  @override
  Widget build(BuildContext context) {
    return AdvancedAppBarBase(
      flow: CollapsedAppBarType.mainScreen,
      child: Column(
        children: [
          SimpleLargeAltAppbar(
            title: headerTitle,
            value: headerValue,
            hasSecondIcon: false,
            show: showIcon,
          ),
          child,
        ],
      ),
    );
  }
}
