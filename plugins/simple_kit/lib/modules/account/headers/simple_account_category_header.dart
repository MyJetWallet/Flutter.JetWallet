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
    required this.isVerified,
    required this.onIconTap,
    required this.icon,
    required this.iconText,
  }) : super(key: key);

  final String userEmail;
  final String userFirstName;
  final String userLastName;
  final bool showUserName;
  final bool isVerified;
  final Function() onIconTap;
  final Widget icon;
  final String iconText;

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
          SIconButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    defaultIcon: const SBackIcon(),
                    pressedIcon: const SBackPressedIcon(),
                  ),
          const SpaceW20(),
          STransparentInkWell(
            onTap: onIconTap,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SColorsLight().black,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                Positioned(
                  top: 8.5,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Text(
                      userEmail.isNotEmpty
                          ? showUserName
                              ? '${userFirstName.substring(0, 1).toUpperCase()}'
                                  '${userLastName.substring(0, 1).toUpperCase()}'
                              : userEmail.substring(0, 1).toUpperCase()
                          : '',
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
          const SpaceW16(),
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
                const SpaceH2(),
                if (isVerified)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      icon,
                      const SpaceW4(),
                      Column(
                        children: [
                          const SpaceH2(),
                          Text(
                            iconText,
                            style: sBodyText2Style.copyWith(
                              color: SColorsLight().green,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
