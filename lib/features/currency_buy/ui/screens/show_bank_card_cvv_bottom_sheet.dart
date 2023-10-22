import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/features/currency_buy/store/preview_buy_with_bank_card_store.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

void showBankCardCvvBottomSheet({
  required BuildContext context,
  required String header,
  required void Function(String) onCompleted,
  required PreviewBuyWithBankCardInput input,
  Function()? onDissmis,
}) {
  return sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: SBottomSheetHeader(
      name: header,
      onTap: () {},
    ),
    onDissmis: () {
      if (onDissmis != null) onDissmis();
    },
    then: (p0) {
      if (onDissmis != null) onDissmis();
    },
    horizontalPadding: 24,
    horizontalPinnedPadding: 24,
    children: [
      Provider<PreviewBuyWithBankCardStore>(
        create: (context) => PreviewBuyWithBankCardStore(input, false),
        builder: (context, child) => CvvBottomSheetBody(
          onCompleted: onCompleted,
          input: input,
        ),
      ),
    ],
  );
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
    final colors = sKit.colors;
    final notifier = PreviewBuyWithBankCardStore.of(context);
    final focusNode = FocusNode();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.cvv_description,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
          maxLines: 10,
        ),
        const SpaceH60(),
        Center(
          child: SizedBox(
            width: 168,
            child: GestureDetector(
              onLongPress: () => notifier.pasteCode(),
              onDoubleTap: () => notifier.pasteCode(),
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
        const SpaceH60(),
      ],
    );
  }
}
