import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_number.dart';
import 'package:simple_kit/simple_kit.dart';

import 'flag_item.dart';

class DialCodeItem extends StatelessObserverWidget {
  const DialCodeItem({
    super.key,
    this.active = false,
    required this.dialCode,
    required this.onTap,
  });

  final bool active;
  final SPhoneNumber dialCode;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
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
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: FlagItem(
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
                              color: active ? colors.blue : colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
