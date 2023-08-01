import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.isValid,
    required this.onTab,
  });

  final bool isValid;
  final void Function() onTab;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SPaddingH24(
          child: GestureDetector(
            onTap: onTab,
            child: SPrimaryButton4(
              active: isValid,
              name: intl.setPhoneNumber_continue,
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}
