import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/payment_methods/store/payment_methods_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

class PaymentCardItem extends StatelessObserverWidget {
  const PaymentCardItem({
    Key? key,
    this.removeDivider = false,
    this.showDelete = true,
    required this.name,
    required this.expirationDate,
    required this.expired,
    required this.onDelete,
    required this.onTap,
    required this.status,
    required this.network,
  }) : super(key: key);

  final bool removeDivider;
  final bool showDelete;
  final String name;
  final String expirationDate;
  final bool expired;
  final Function() onDelete;
  final Function() onTap;
  final CircleCardStatus status;
  final CircleCardNetwork network;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final notifier = PaymentMethodsStore();
    final isDisabled = expired || status == CircleCardStatus.failed;

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: () {
        onTap();
        if (status == CircleCardStatus.failed) {
          notifier.showFailure();
        }
      },
      child: Container(
        height: 64.0,
        padding: const EdgeInsets.only(
          top: 9.0,
          left: 24.0,
          right: 24.0,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getNetworkIcon(),
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
                                  color:
                                      isDisabled ? colors.grey2 : colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SpaceW10(),
                          if (showDelete)
                            Container(
                              transform: Matrix4.translationValues(9, 0, 0),
                              child: SIconButton(
                                onTap: onDelete,
                                defaultIcon: const SDeleteIcon(),
                              ),
                            ),
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
                                    color:
                                        isDisabled ? colors.red : colors.grey3,
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
              ),
          ],
        ),
      ),
    );
  }

  Widget getNetworkIcon() {
    switch (network) {
      case CircleCardNetwork.visa:
        return const SVisaCardIcon(
          width: 40,
          height: 25,
        );
      case CircleCardNetwork.mastercard:
        return const SMasterCardIcon(
          width: 40,
          height: 25,
        );
      default:
        return SizedBox(
          width: 40,
          height: 25,
          child: Center(
            child: SActionDepositIcon(
              color: sKit.colors.blue,
            ),
          ),
        );
    }
  }
}
