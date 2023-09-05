import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class DepositCategoryDescription extends StatelessObserverWidget {
  const DepositCategoryDescription({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      height: 21.0,
      padding: const EdgeInsets.only(
        left: 24.0,
      ),
      child: Row(
        children: [
          Text(
            text,
            style: sCaptionTextStyle.copyWith(
              color: colors.grey3,
            ),
          ),
          const SpaceW10(),
          Expanded(
            child: SDivider(
              color: colors.grey3,
            ),
          ),
        ],
      ),
    );
  }
}
