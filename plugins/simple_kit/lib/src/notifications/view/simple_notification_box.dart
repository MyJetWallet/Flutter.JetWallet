import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SNotificationBox extends StatelessWidget {
  const SNotificationBox({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceH60(),
        Container(
          decoration: BoxDecoration(
            color: SColorsLight().red,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(20.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SErrorIcon(
                color: SColorsLight().white,
              ),
              const SpaceW10(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH2(),
                    Text(
                      text,
                      maxLines: 10,
                      style: sBodyText1Style.copyWith(
                        color: SColorsLight().white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
