import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

const _defaultAlert = 'Connecting to server… Please wait or try again later';

class SActionConfirmAlert extends StatelessWidget {
  const SActionConfirmAlert({
    super.key,
    this.alert,
  });

  final String? alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: SColorsLight().grey4,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.only(
        top: 14,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SErrorIcon(
              color: SColorsLight().red,
            ),
          ),
          const SpaceW10(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH2(),
                Text(
                  alert ?? _defaultAlert,
                  maxLines: 2,
                  style: sBodyText1Style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
