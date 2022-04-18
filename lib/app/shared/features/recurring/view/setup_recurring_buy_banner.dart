import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';

class SetupRecurringBuyBanner extends HookWidget {
  const SetupRecurringBuyBanner({
    Key? key,
    this.totalRecurringBuy,
    required this.name,
    required this.isRecurring,
    required this.onTap,
  }) : super(key: key);

  final String? totalRecurringBuy;
  final String name;
  final bool isRecurring;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SliverToBoxAdapter(
      child: SPaddingH24(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 24.0),
            height: 136,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: isRecurring ? colors.blueLight : colors.white,
              border: Border.all(
                width: 3.0,
                color: isRecurring ? colors.blueLight : colors.grey5,
              ),
            ),
            child: Column(
              children: [
                const SpaceH13(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Todo:
                    Container(
                      height: 48,
                      width: 48,
                      padding: isRecurring
                          ? EdgeInsets.zero
                          : const EdgeInsets.all(8.0),
                      child: isRecurring
                          ? Image.asset(
                              recurringBuyImage,
                              height: 24,
                              width: 24,
                            )
                          : SvgPicture.asset(
                              recurringBuyAsset,
                              height: 24,
                              width: 24,
                            ),
                    ),
                  ],
                ),
                const SpaceH10(),
                Column(
                  children: [
                    Text(
                      name,
                      style: sBodyText2Style,
                      textAlign: TextAlign.center,
                    ),
                    if (isRecurring)
                      Text(
                        totalRecurringBuy!,
                        style: sSubtitle2Style,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
