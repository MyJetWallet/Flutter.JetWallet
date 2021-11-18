import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../simple_kit.dart';

class SimpleAccountCategoryHeader extends StatelessWidget {
  const SimpleAccountCategoryHeader({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 52.h,
        bottom: 20.h,
      ),
      height: 120.h,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24.r,
            backgroundColor: SColorsLight().blue,
            child: Text(
              userEmail.substring(0, 2).toUpperCase(),
              style: sSubtitle2Style,
            ),
          ),
          const SpaceW20(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Todo: change 'Jonh Shooter' on username from provider
                // Text(
                //   'John Shooter',
                //   style: sTextH5Style,
                // ),
                const SpaceH2(),
                Text(
                  userEmail,
                  style: sSubtitle3Style.copyWith(
                    color: SColorsLight().grey1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
