import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class PaymentCardItem extends HookWidget {
  const PaymentCardItem({
    Key? key,
    this.removeDivider = false,
    required this.name,
    required this.expirationDate,
    required this.expired,
    required this.onDelete,
  }) : super(key: key);

  final bool removeDivider;
  final String name;
  final String expirationDate;
  final bool expired;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      height: 88.0,
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SActionDepositIcon(
                color: colors.black,
              ),
              const SpaceW20(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Baseline(
                            baseline: 18.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style.copyWith(
                                color: colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SpaceW10(),
                        SIconButton(
                          onTap: onDelete,
                          defaultIcon: const SDeleteIcon(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Baseline(
                              baseline: 14.0,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                expirationDate,
                                style: sCaptionTextStyle.copyWith(
                                  color: expired ? colors.red : colors.grey3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (!removeDivider)
            const SDivider(
              width: double.infinity,
            )
        ],
      ),
    );
  }
}
