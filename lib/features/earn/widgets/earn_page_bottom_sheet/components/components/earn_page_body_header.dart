import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnPageBodyHeader extends StatelessWidget {
  const EarnPageBodyHeader({
    Key? key,
    required this.colors,
  }) : super(key: key);

  final SimpleColors colors;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${intl.earn_program}\n',
                style: sTextH2Style.copyWith(
                  color: colors.green,
                ),
              ),
              TextSpan(
                text: intl.earn_sheet_subtitle,
                style: sTextH2Style.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
