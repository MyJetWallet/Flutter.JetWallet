import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SDialCodeItem extends StatelessWidget {
  const SDialCodeItem({
    Key? key,
    this.active = false,
    required this.dialCode,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final SPhoneNumber dialCode;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64.0,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: SColorsLight().grey2,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SpaceW10(),
                  Baseline(
                    baseline: 38.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 68.0,
                          child: Text(
                            dialCode.countryCode,
                            style: sSubtitle2Style.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                        const SpaceW10(),
                        SizedBox(
                          width: size.width - 160.0,
                          child: Text(
                            dialCode.countryName,
                            style: sSubtitle2Style.copyWith(
                              color: active
                                  ? SColorsLight().blue
                                  : SColorsLight().black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SDivider()
            ],
          ),
        ),
      ),
    );
  }
}
