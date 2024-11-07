import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../../simple_kit.dart';

// TODO rename to SAccount
class SimpleAccountCategoryButton extends StatelessWidget {
  const SimpleAccountCategoryButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.isSDivider,
    this.onSwitchChanged,
    this.switchValue = false,
    this.notification = false,
    this.showEditIcon = false,
  });

  final Widget icon;
  final Function()? onTap;
  final String title;
  final bool isSDivider;
  final Function(bool)? onSwitchChanged;
  final bool switchValue;
  final bool notification;
  final bool showEditIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: showEditIcon ? Colors.transparent : SColorsLight().grey5,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: showEditIcon ? null : onTap,
      child: SPaddingH24(
        child: Column(
          children: <Widget>[
            Container(
              height: 30.0,
              margin: const EdgeInsets.symmetric(
                vertical: 18.0,
              ),
              child: Stack(
                children: [
                  Row(
                    children: <Widget>[
                      icon,
                      const SpaceW20(),
                      Expanded(
                        child: Text(
                          title,
                          style: sSubtitle2Style,
                        ),
                      ),
                      if (onSwitchChanged != null)
                        Container(
                          width: 40.0,
                          height: 22.0,
                          decoration: BoxDecoration(
                            color: switchValue ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Switch(
                            value: switchValue,
                            onChanged: onSwitchChanged,
                            activeColor: Colors.white,
                            activeTrackColor: Colors.black,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  if (notification)
                    const Positioned(
                      right: 0,
                      top: 3,
                      child: SErrorIcon(),
                    ),
                  if (showEditIcon)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: SIconButton(
                        onTap: onTap,
                        defaultIcon: const SEditIcon(),
                        pressedIcon: SEditIcon(color: SColorsLight().grey3),
                      ),
                    ),
                ],
              ),
            ),
            if (isSDivider) const SDivider(),
          ],
        ),
      ),
    );
  }
}
