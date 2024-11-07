import 'package:flutter/material.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';

class ConvertDropdownButton extends StatelessWidget {
  const ConvertDropdownButton({
    super.key,
    required this.onTap,
    required this.currency,
  });

  final Function() onTap;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return STransparentInkWell(
      onTap: onTap,
      child: Row(
        children: [
          NetworkIconWidget(
            currency.iconUrl,
          ),
          const SpaceW10(),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 90.0,
            ),
            child: Text(
              currency.symbol,
              maxLines: 1,
              style: sTextH4Style,
            ),
          ),
          const SpaceW10(),
          const SAngleDownIcon(),
        ],
      ),
    );
  }
}
