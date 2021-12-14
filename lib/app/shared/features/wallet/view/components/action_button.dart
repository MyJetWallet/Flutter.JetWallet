import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/is_balance_empty.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';

class ActionButton extends HookWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final isNotEmptyBalance = !isBalanceEmpty(currencies);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SDivider(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: SPrimaryButton1(
            name: 'Action',
            onTap: () {
              // TODO(any): Add action button sheet
            },
            active: true,
          ),
        ),
      ],
    );
  }
}
