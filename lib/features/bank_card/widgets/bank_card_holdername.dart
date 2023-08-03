import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:simple_kit/simple_kit.dart';

class BankCardHolderName extends StatelessWidget {
  const BankCardHolderName({super.key});

  @override
  Widget build(BuildContext context) {
    return SFieldDividerFrame(
      child: SStandardField(
        controller: TextEditingController(
          text: '${sUserInfo.firstName} ${sUserInfo.lastName}',
        ),
        readOnly: true,
        enabled: false,
        hideClearButton: true,
        labelText: intl.addCircleCard_cardholderName,
        textCapitalization: TextCapitalization.sentences,
        hideSpace: true,
        grayLabel: true,
      ),
    );
  }
}
