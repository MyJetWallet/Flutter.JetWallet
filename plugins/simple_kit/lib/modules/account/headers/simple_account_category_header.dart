import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SimpleAccountCategoryHeader extends StatelessWidget {
  const SimpleAccountCategoryHeader({
    super.key,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    required this.showUserName,
    required this.isVerified,
    required this.onIconTap,
    required this.icon,
    required this.iconText,
  });

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
                  width: 48,
                  height: 48,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      end: Alignment(0.90, -0.44),
                      begin: Alignment(-0.9, 0.44),
                      colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
                    ),
                    shape: OvalBorder(),
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
