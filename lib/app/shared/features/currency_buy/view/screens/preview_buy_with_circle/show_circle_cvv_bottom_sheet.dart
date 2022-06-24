import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import '../../../model/preview_buy_with_circle_input.dart';
import '../../../notifier/preview_buy_with_circle_notifier/preview_buy_with_circle_notipod.dart';

void showCircleCvvBottomSheet({
  required BuildContext context,
  required String header,
  required void Function(String) onCompleted,
  required PreviewBuyWithCircleInput input,
}) {
  return sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: SBottomSheetHeader(
      name: header,
    ),
    horizontalPadding: 24,
    horizontalPinnedPadding: 24,
    children: [
      CvvBottomSheetBody(
        onCompleted: onCompleted,
        input: input,
      ),
    ],
  );
}

class CvvBottomSheetBody extends HookWidget {
  const CvvBottomSheetBody({
    Key? key,
    required this.onCompleted,
    required this.input,
  }) : super(key: key);

  final void Function(String) onCompleted;
  final PreviewBuyWithCircleInput input;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final notifier = useProvider(previewBuyWithCircleNotipod(input).notifier);
    final focusNode = FocusNode();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.previewBuyWithCircle_cvvDescription,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
        const SpaceH60(),
        Center(
          child: SizedBox(
            width: 168,
            child:
            GestureDetector(
              onLongPress: () => notifier.pasteCode(),
              onDoubleTap: () => notifier.pasteCode(),
              onTap: () {
                focusNode.unfocus();
                Future.delayed(const Duration(microseconds: 100), () {
                  if (!focusNode.hasFocus) {
                    focusNode.requestFocus();
                  }
                });
              },
              child: AbsorbPointer(
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
                  hintStyle: sTextH2Style.copyWith(
                    color: colors.grey4,
                  ),
                  textStyle: sTextH2Style.copyWith(
                    color: colors.black,
                    fontSize: (Platform.isIOS) ? 24 : 16,
                  ),
                  onChanged: (_) => {},
                  onCompleted: onCompleted,
                ),
              ),
            ),
          ),
        ),
        const SpaceH60(),
      ],
    );
  }
}
