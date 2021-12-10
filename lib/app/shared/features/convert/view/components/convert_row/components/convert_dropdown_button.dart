import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../models/currency_model.dart';

class ConvertDropdownButton extends StatelessWidget {
  const ConvertDropdownButton({
    Key? key,
    required this.onTap,
    required this.currency,
  }) : super(key: key);

  final Function() onTap;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return STransparentInkWell(
      onTap: onTap,
      child: Row(
        children: [
          SNetworkSvg24(
            url: currency.iconUrl,
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
