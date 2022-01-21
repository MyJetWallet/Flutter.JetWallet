import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../helpers/flag_icon_svg.dart';


class DialCodeItem extends HookWidget {
  const DialCodeItem({
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
    final colors = useProvider(sColorPod);
    final size = MediaQuery.of(context).size;

    return InkWell(
      highlightColor: colors.grey5,
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
                    padding: const EdgeInsets.only(top: 20,),
                    child: FlagIconSvg(
                      countryCode: dialCode.isoCode,
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
                              color: colors.grey3,
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
                                  ? colors.blue
                                  : colors.black,
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
