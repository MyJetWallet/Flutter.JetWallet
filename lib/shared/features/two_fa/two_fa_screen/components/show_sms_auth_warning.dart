import 'package:flutter/material.dart';

import '../../two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../two_fa_phone/view/two_fa_phone.dart';

void showSmsAuthWarning(BuildContext context) {
  showDialog(
    context: context,
    builder: (builderContext) {
      return AlertDialog(
        title: const Text(
          'Are you sure you want to disable SMS Authentication?',
        ),
        content: const Text(
          'я понимаю и принимаю все риски связанные с понижением '
          'уровня безопасности аккаунта. В целях безопасности, '
          'возможность вывода средств на аккаунте, будет '
          'приостановлена на 24 часа',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(builderContext);
            },
            child: const Text(
              'Later',
            ),
          ),
          TextButton(
            onPressed: () {
              TwoFaPhone.pushReplacement(builderContext, const Security());
            },
            child: const Text(
              'Continue',
            ),
          ),
        ],
      );
    },
  );
}
