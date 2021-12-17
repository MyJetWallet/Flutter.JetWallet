import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SContactItem extends StatelessWidget {
  const SContactItem({
    Key? key,
    this.onTap,
    this.valid = true,
    required this.name,
    required this.phone,
  }) : super(key: key);

  final Function()? onTap;
  final bool valid;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: valid ? onTap : null,
      child: SPaddingH24(
        child: SizedBox(
          height: 80.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: valid ? SColorsLight().blue : SColorsLight().grey4,
                  ),
                  child: valid
                      ? Center(
                          child: Text(
                            (name != phone) ? initialsFrom(name) : '#',
                            style: sSubtitle3Style.copyWith(
                              color: SColorsLight().white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SpaceW20(),
              SizedBox(
                width: size.width - 108.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Baseline(
                      baseline: (name != phone) ? 38.0 : 48.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        name,
                        style: sSubtitle2Style.copyWith(
                          color: valid
                              ? SColorsLight().black
                              : SColorsLight().grey1,
                        ),
                      ),
                    ),
                    if (name != phone)
                      Baseline(
                        baseline: 14.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          phone,
                          style: sBodyText2Style.copyWith(
                            color: SColorsLight().grey2,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
