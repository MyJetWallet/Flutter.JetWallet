import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountStatusBanner extends StatelessObserverWidget {
  const AccountStatusBanner({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.mainColor,
    required this.textColor,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final Function() onTap;
  final Color mainColor;
  final Color textColor;

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: 56,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Row(
            children: [
              icon,
              const SpaceW10(),
              Text(
                title,
                style: sSubtitle2Style.copyWith(
                  color: textColor,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              SBlueRightArrowIcon(
                color: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
