import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../simple_kit.dart';


class SimpleAccountBanner extends StatelessWidget {
  const SimpleAccountBanner({
    Key? key,
    required this.header,
    required this.description,
  }) : super(key: key);

  final String header;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.86.sw,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: SColorsLight().blueLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sTextH5Style,
          ),
          const SpaceH4(),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: sBodyText1Style,
          ),
        ],
      ),
    );
  }
}
