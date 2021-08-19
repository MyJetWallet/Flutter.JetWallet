import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../components/asset_input_error.dart';
import '../../../../../helpers/input_helpers.dart';
import 'components/swap_button.dart';

class StackBetweenRows extends StatelessWidget {
  const StackBetweenRows({
    Key? key,
    required this.onSwapButton,
    required this.inputError,
  }) : super(key: key);

  final Function() onSwapButton;
  final InputError inputError;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            const SpaceH10(),
            SwapButton(
              onPressed: onSwapButton,
            ),
            const SpaceH10(),
          ],
        ),
        if (inputError.isActive)
          Padding(
            padding: EdgeInsets.only(
              top: 4.h,
            ),
            child: AssetInputError(
              alignment: Alignment.topRight,
              text: inputError.value,
            ),
          )
      ],
    );
  }
}
