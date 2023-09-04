import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/24x24/public/filter/simple_filter_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/filter/simple_pressed_filter_icon.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../bottom_navigation_bar/components/notification_box.dart';

class SimpleMarketHeaderFilter extends StatefulWidget {
  const SimpleMarketHeaderFilter({
    super.key,
    this.onFilterButtonTap,
    this.activeFilters = 0,
  });

  final void Function()? onFilterButtonTap;
  final int activeFilters;

  @override
  State<SimpleMarketHeaderFilter> createState() =>
      _SimpleMarketHeaderFilterState();
}

class _SimpleMarketHeaderFilterState extends State<SimpleMarketHeaderFilter> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpaceH11(),
        SizedBox(
          width: 56.0,
          height: 34.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: widget.onFilterButtonTap,
                onHighlightChanged: (value) {
                  setState(() {
                    highlighted = value;
                  });
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    highlighted
                        ? const SPressedFilterIcon()
                        : const SFilterIcon(),
                  ],
                ),
              ),
              NotificationBox(
                notifications: widget.activeFilters,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
