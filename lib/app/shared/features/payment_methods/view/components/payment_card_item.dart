import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../notifier/payment_methods_notipod.dart';

class PaymentCardItem extends HookWidget {
  const PaymentCardItem({
    Key? key,
    this.removeDivider = false,
    required this.name,
    required this.expirationDate,
    required this.expired,
    required this.onDelete,
    required this.status,
  }) : super(key: key);

  final bool removeDivider;
  final String name;
  final String expirationDate;
  final bool expired;
  final Function() onDelete;
  final CircleCardStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final notifier = useProvider(paymentMethodsNotipod.notifier);
    final isDisabled = expired || status == CircleCardStatus.failed;

    return Container(
      height: 88.0,
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
      ),
      child: InkWell(
        highlightColor: colors.grey5,
        splashColor: Colors.transparent,
        onTap: () {
          if (status == CircleCardStatus.failed) {
            notifier.showFailure();
          }
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SActionDepositIcon(
                  color: isDisabled ? colors.grey2 : colors.black,
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
                                  color: isDisabled
                                      ? colors.grey2
                                      : colors.black,
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
                                  status == CircleCardStatus.pending
                                      ? intl.paymentMethod_CardIsProcessing
                                      : status == CircleCardStatus.failed
                                      ? intl.paymentMethod_Failed
                                      : expirationDate,
                                  style: sCaptionTextStyle.copyWith(
                                    color: isDisabled
                                        ? colors.red
                                        : colors.grey3,
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
      ),
    );
  }
}
