import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/send_gift/gift_model.dart';

void expairedGiftBottomSheet({
  required BuildContext context,
  required GiftModel giftModel,
}) {
  final receiverContact = giftModel.toEmail ?? giftModel.toPhoneNumber;
  final text =
      '''$receiverContact has not claimed your gift of ${giftModel.amount} ${giftModel.assetSymbol} in time. This gift was credited back to your Simple App balance''';

  sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: text,
    primaryButtonName: intl.card_got_it,
    image: Image.asset(
      congratsAsset,
      height: 80,
      width: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
