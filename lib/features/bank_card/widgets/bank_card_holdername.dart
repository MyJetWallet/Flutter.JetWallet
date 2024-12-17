import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';

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
