import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../../components/simple_icon_button.dart';

class SimpleMarketHeaderTitle extends StatelessWidget {
  const SimpleMarketHeaderTitle({
    Key? key,
    required this.title,
    required this.onSearchButtonTap,
  }) : super(key: key);

  final String title;
  final Function() onSearchButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        STextH2(
          text: title,
        ),
        const Spacer(),
        SIconButton(
          onTap: onSearchButtonTap,
          defaultIcon: const SSearchIcon(),
          pressedIcon: const SSearchPressedIcon(),
        ),
      ],
    );
  }
}
