import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SimpleAccountCategoryHeader extends StatelessWidget {
  const SimpleAccountCategoryHeader({
    Key? key,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    required this.showUserName,
  }) : super(key: key);

  final String userEmail;
  final String userFirstName;
  final String userLastName;
  final bool showUserName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 48.0,
        bottom: 20.0,
      ),
      height: 120.0,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24.0,
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
                const SpaceH2(),
                if (showUserName)
                Text(
                  '$userFirstName $userLastName',
                  style: sTextH5Style.copyWith(
                    color: SColorsLight().black,
                  ),
                ),
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
