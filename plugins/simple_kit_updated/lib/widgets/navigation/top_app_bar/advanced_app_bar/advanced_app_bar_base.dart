import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

enum CollapsedAppBarType { mainScreen, wallet, account }

class AdvancedAppBarBase extends StatelessWidget {
  const AdvancedAppBarBase({
    Key? key,
    required this.child,
    required this.flow,
    required this.isShortVersion,
  }) : super(key: key);

  final Widget child;
  final CollapsedAppBarType flow;

  final bool isShortVersion;

  @override
  Widget build(BuildContext context) {
    LinearGradient getGradient() {
      switch (flow) {
        case CollapsedAppBarType.mainScreen:
          return SColorsLight().mainScreenGradient;
        case CollapsedAppBarType.account:
          return SColorsLight().accountGradient;
        case CollapsedAppBarType.wallet:
          return SColorsLight().walletGradient;
        default:
          return SColorsLight().walletGradient;
      }
    }

    double getHeightWithoutCarousel() {
      switch (flow) {
        case CollapsedAppBarType.mainScreen:
          return 270;
        case CollapsedAppBarType.account:
          return 213;
        case CollapsedAppBarType.wallet:
          return 229;
        default:
          return 265;
      }
    }

    double getHeightWithCarousel() {
      switch (flow) {
        case CollapsedAppBarType.mainScreen:
          return 270;
        case CollapsedAppBarType.account:
          return 251;
        case CollapsedAppBarType.wallet:
          return 267;
        default:
          return 265;
      }
    }

    return Container(
      height: !isShortVersion ? getHeightWithoutCarousel() : getHeightWithCarousel(),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: getGradient(),
      ),
      child: Stack(
        children: [
          Assets.images.appbarBg.simpleImg(
            height: 267,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          child,
        ],
      ),
    );
  }
}
