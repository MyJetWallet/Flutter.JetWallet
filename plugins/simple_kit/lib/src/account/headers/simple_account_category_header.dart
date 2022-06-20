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
          Stack(
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
                left: 0,
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
