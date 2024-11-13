import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/payment_methods/store/payment_methods_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

class PaymentCardItem extends StatelessObserverWidget {
  const PaymentCardItem({
    super.key,
    this.removeDivider = false,
    this.showDelete = true,
    this.showEdit = false,
    this.onEdit,
    this.currency,
    required this.lable,
    required this.last4numbers,
    required this.expirationDate,
    required this.expired,
    required this.onDelete,
    required this.onTap,
    required this.status,
    required this.network,
  });

  final bool removeDivider;
  final bool showDelete;
  final bool showEdit;
  final String lable;
  final String last4numbers;
  final String expirationDate;
  final String? currency;
  final bool expired;
  final Function() onDelete;
  final Function()? onEdit;
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
        height: 72.0,
        padding: const EdgeInsets.only(
          top: 12.0,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1000000,
                                  child: Text(
                                    lable,
                                    style: STStyles.subtitle1.copyWith(
                                      color: isDisabled ? colors.grey2 : colors.black,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' ••••',
                                  style: STStyles.subtitle1.copyWith(
                                    color: isDisabled ? colors.grey2 : colors.black,
                                  ),
                                ),
                                Text(
                                  last4numbers,
                                  style: STStyles.subtitle1.copyWith(
                                    color: isDisabled ? colors.grey2 : colors.black,
                                  ),
                                ),
                                const SpaceW8(),
                                if (currency != null)
                                  Baseline(
                                    baseline: 16.0,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Text(
                                      currency ?? '',
                                      style: STStyles.captionMedium.copyWith(
                                        color: sKit.colors.grey1,
                                        height: 1.38,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (showDelete)
                            Container(
                              transform: Matrix4.translationValues(9, 0, 0),
                              child: SIconButton(
                                onTap: onDelete,
                                defaultIcon: const SDeleteIcon(),
                              ),
                            ),
                          if (showEdit) ...[
                            const SpaceW8(),
                            SIconButton(
                              onTap: onEdit,
                              defaultIcon: const SEditIcon(),
                              pressedIcon: const SEditIcon(
                                color: Color(0xFFA8B0BA),
                              ),
                            ),
                          ],
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
                                  style: STStyles.captionSemibold.copyWith(
                                    color: isDisabled ? colors.red : colors.grey3,
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
            if (!removeDivider) const SDivider(),
          ],
        ),
      ),
    );
  }

  Widget getNetworkIcon() {
    switch (network) {
      case CircleCardNetwork.VISA:
        return const SVisaCardIcon(
          width: 40,
          height: 25,
        );
      case CircleCardNetwork.MASTERCARD:
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
