import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/components/spacers.dart';

class AssetSelectorButton extends StatelessWidget {
  const AssetSelectorButton({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SpaceW4(),
          Icon(
            FontAwesomeIcons.angleDown,
            size: 20.r,
          )
        ],
      ),
    );
  }
}
