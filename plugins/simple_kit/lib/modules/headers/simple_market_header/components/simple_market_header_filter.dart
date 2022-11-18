import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/filter/simple_filter_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/filter/simple_pressed_filter_icon.dart';
import 'package:simple_kit/simple_kit.dart';

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
    return InkWell(
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
          highlighted ? const SPressedFilterIcon() : const SFilterIcon(),
          if (widget.activeFilters != 0) ...[
            Positioned(
              left: 9,
              bottom: 9,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 6.0,
                  right: 6.0,
                ),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: SColorsLight().blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.activeFilters}',
                  style: sBodyText1Style.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: SColorsLight().white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
