import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class DepositInfo extends StatelessObserverWidget {
  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      width: double.infinity,
      color: colors.blueLight,
      height: 68.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Text(
            intl.depositInfo_text,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: STStyles.body2Medium,
          ),
        ),
      ),
    );
  }
}
