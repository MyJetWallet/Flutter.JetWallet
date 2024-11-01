import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SContactIconPreview extends StatelessWidget {
  const SContactIconPreview({
    super.key,
    this.valid = true,
    required this.isManualEnter,
    required this.name,
    required this.phone,
  });

  final bool valid;
  final bool isManualEnter;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: valid ? SColorsLight().blue : SColorsLight().grey4,
      ),
      child: isManualEnter
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                contactAsset,
              ),
            )
          : valid
              ? Center(
                  child: Text(
                    (name != phone) ? initialsFrom(name) : '#',
                    style: sSubtitle3Style.copyWith(
                      color: SColorsLight().white,
                    ),
                  ),
                )
              : null,
    );
  }
}
