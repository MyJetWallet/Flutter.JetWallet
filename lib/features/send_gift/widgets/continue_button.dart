import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../store/receiver_datails_store.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key, required this.store});

  final ReceiverDatailsStore store;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SPaddingH24(
          child: SPrimaryButton4(
            active: store.isformValid,
            name: intl.setPhoneNumber_continue,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
          ),
        );
      },
    );
  }
}
