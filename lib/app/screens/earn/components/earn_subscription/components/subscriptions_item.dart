import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class SubscriptionsItem extends HookWidget {
  const SubscriptionsItem({
    Key? key,
    this.days = 0,
    required this.isHot,
    required this.apy,
  }) : super(key: key);

  final bool isHot;
  final Decimal apy;
  final int days;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

    return Column(
      children: [
        InkWell(
          highlightColor: colors.grey5,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {},
          child: Ink(
            height: 88,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: colors.grey4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isHot ? '${intl.earn_hot} ${String.fromCharCodes(
                              Runes('\u{1F525}'),
                          )}' : intl.earn_flexible,
                          style: sSubtitle2Style.copyWith(
                            color: colors.black,
                          ),
                        ),
                        if (days > 0)
                          Text(
                            '${intl.earn_for}  $days ${intl.earn_day} ',
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '$apy%',
                      style: sTextH2Style.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SpaceH10(),
      ],
    );
  }
}
