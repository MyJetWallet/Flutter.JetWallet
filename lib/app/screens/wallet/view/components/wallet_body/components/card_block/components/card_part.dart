import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardPart extends StatelessWidget {
  const CardPart({
    Key? key,
    required this.left,
  }) : super(key: key);

  final bool left;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.25.sh,
      width: 0.05.sw,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: left
            ? BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
      ),
      child: const SizedBox(),
    );
  }
}
