import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';

class EarnOfferItem extends StatelessWidget {
  const EarnOfferItem({
    required this.percentage,
    required this.cryptoName,
    required this.onTap,
    this.trailingIcon,
    this.isSingleOffer = false,
    super.key,
  });
  final String? percentage;
  final String cryptoName;
  final void Function()? onTap;
  final Widget? trailingIcon;
  final bool isSingleOffer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: ChipsSuggestionM(
        title: isSingleOffer
            ? double.parse(percentage ?? '0').toFormatPercentCount()
            : '${intl.earn_up_to} ${double.parse(percentage ?? '0').toFormatPercentCount()}',
        subtitle: cryptoName,
        onTap: onTap,
        icon: trailingIcon != null
            ? CircleAvatar(
                backgroundColor: Colors.transparent,
                child: trailingIcon,
              )
            : null,
      ),
    );
  }
}
