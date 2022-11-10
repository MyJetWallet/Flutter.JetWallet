import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_transparent_ink_well.dart';

import '../../../simple_kit.dart';

class SimpleAccountCategoryHeader extends StatelessWidget {
  const SimpleAccountCategoryHeader({
    Key? key,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    required this.showUserName,
    required this.onIconTap,
  }) : super(key: key);

  final String userEmail;
  final String userFirstName;
  final String userLastName;
  final bool showUserName;
  final Function() onIconTap;

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
          STransparentInkWell(
            onTap: onIconTap,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SColorsLight().blue,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                Positioned(
                  top: 8.5,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Text(
                      showUserName
                          ? '${userFirstName.substring(0, 1).toUpperCase()}'
                              '${userLastName.substring(0, 1).toUpperCase()}'
                          : userEmail.substring(0, 1).toUpperCase(),
                      style: sSubtitle2Style.copyWith(
                        color: SColorsLight().white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
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
