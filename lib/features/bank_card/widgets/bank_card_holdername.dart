import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class BankCardHolderName extends StatelessWidget {
  const BankCardHolderName({super.key});

  @override
  Widget build(BuildContext context) {
    return SInput(
      controller: TextEditingController(
        text: '${sUserInfo.firstName} ${sUserInfo.lastName}',
      ),
      isDisabled: true,
      label: intl.addCircleCard_cardholderName,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
