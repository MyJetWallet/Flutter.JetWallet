import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Future<void> showBankCardCvvBottomSheet({
  required BuildContext context,
  required String header,
  required void Function(String) onCompleted,
  required PreviewBuyWithBankCardInput input,
  dynamic Function(dynamic)? onDissmis,
}) async {
  return showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: header,
    ),
    children: [
      CvvBottomSheetBody(
        onCompleted: onCompleted,
        input: input,
      ),
    ],
  ).then((p0) {
    if (onDissmis != null) onDissmis(p0);
  });
}

class CvvBottomSheetBody extends StatelessObserverWidget {
  const CvvBottomSheetBody({
    super.key,
    required this.onCompleted,
    required this.input,
  });

  final void Function(String) onCompleted;
  final PreviewBuyWithBankCardInput input;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final focusNode = FocusNode();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.cvv_description,
          style: STStyles.body1Medium.copyWith(
            color: colors.gray10,
          ),
          maxLines: 10,
        ),
        const SpaceH60(),
        Center(
          child: SizedBox(
            width: 168,
            child: GestureDetector(
              onLongPress: () {},
              onDoubleTap: () {},
              child: PinCodeTextField(
                focusNode: focusNode,
                length: 3,
                autoFocus: true,
                appContext: context,
                obscureText: true,
                autoDisposeControllers: false,
                animationType: AnimationType.fade,
                useExternalAutoFillGroup: true,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: colors.white,
                cursorColor: colors.blue,
                hintCharacter: 'X',
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  fieldWidth: 56.0,
                  fieldHeight: 42.0,
                  selectedColor: colors.white,
                  activeColor: colors.white,
                  inactiveColor: colors.white,
                ),
                hintStyle: STStyles.header3.copyWith(
                  color: colors.gray4,
                ),
                textStyle: STStyles.header3.copyWith(
                  color: colors.black,
                  fontSize: (Platform.isIOS) ? 24 : 16,
                ),
                onChanged: (_) => {},
                onCompleted: (s) {
                  onCompleted(s);
                },
              ),
            ),
          ),
        ),
        const SpaceH60(),
      ],
    );
  }
}
