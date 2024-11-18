import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SNumericLargeInput extends StatelessWidget {
  const SNumericLargeInput({
    super.key,
    required this.primaryAmount,
    required this.primarySymbol,
    this.secondaryAmount,
    this.secondarySymbol,
    required this.onSwap,
    this.errorText,
    this.optionText,
    this.optionOnTap,
    required this.pasteLabel,
    required this.onPaste,
    this.showSwopButton = true,
    this.showMaxButton = false,
    this.loadingMaxButton = false,
    this.onMaxTap,
  });

  final String primaryAmount;
  final String primarySymbol;
  final String? secondaryAmount;
  final String? secondarySymbol;
  final void Function()? onSwap;
  final String? errorText;
  final String? optionText;
  final void Function()? optionOnTap;
  final String pasteLabel;
  final VoidCallback onPaste;
  final bool showSwopButton;
  final bool showMaxButton;
  final bool loadingMaxButton;
  final void Function()? onMaxTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (primaryAmount.length <= 6)
                      Theme(
                        data: ThemeData(
                          textSelectionTheme: const TextSelectionThemeData(
                            cursorColor: Colors.transparent,
                            selectionColor: Colors.transparent,
                            selectionHandleColor: Colors.transparent,
                          ),
                        ),
                        child: SelectionArea(
                          contextMenuBuilder: (context, editableTextState) {
                            final List<ContextMenuButtonItem> buttonItems = [];
                            buttonItems.insert(
                              0,
                              ContextMenuButtonItem(
                                label: pasteLabel,
                                onPressed: () {
                                  ContextMenuController.removeAny();
                                  onPaste();
                                },
                              ),
                            );

                            return AdaptiveTextSelectionToolbar.buttonItems(
                              anchors: editableTextState.contextMenuAnchors,
                              buttonItems: buttonItems,
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AutoSizeText(
                                primaryAmount,
                                maxLines: 1,
                                style: STStyles.header1.copyWith(
                                  color: primaryAmount == '0' ? colors.gray8 : colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: AutoSizeText(
                                  ' $primarySymbol',
                                  maxLines: 1,
                                  style: STStyles.header3.copyWith(
                                    color: colors.gray8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Theme(
                        data: ThemeData(
                          textSelectionTheme: const TextSelectionThemeData(
                            cursorColor: Colors.transparent,
                            selectionColor: Colors.transparent,
                            selectionHandleColor: Colors.transparent,
                          ),
                        ),
                        child: SelectionArea(
                            contextMenuBuilder: (context, editableTextState) {
                              final List<ContextMenuButtonItem> buttonItems = [];
                              buttonItems.insert(
                                0,
                                ContextMenuButtonItem(
                                  label: pasteLabel,
                                  onPressed: () {
                                    ContextMenuController.removeAny();
                                    onPaste();
                                  },
                                ),
                              );

                              return AdaptiveTextSelectionToolbar.buttonItems(
                                anchors: editableTextState.contextMenuAnchors,
                                buttonItems: buttonItems,
                              );
                            },
                            child: AutoSizeText.rich(
                              TextSpan(
                                text: '$primaryAmount ',
                                style: STStyles.header4.copyWith(
                                  color: primaryAmount == '0' ? colors.gray8 : colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text: primarySymbol,
                                      style: STStyles.header4.copyWith(
                                        color: colors.gray8,
                                      )),
                                ],
                              ),
                            )),
                      ),
                    const SizedBox(height: 4),
                    if (secondaryAmount != null)
                      AutoSizeText(
                        '$secondaryAmount $secondarySymbol',
                        minFontSize: 4.0,
                        maxLines: 1,
                        style: STStyles.subtitle2.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (showMaxButton) ...[
                    SafeGesture(
                      onTap: onMaxTap,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: colors.gray2,
                          shape: const OvalBorder(),
                        ),
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: loadingMaxButton
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FastCircularProgressIndicator(
                                    speed: 0.8,
                                    color: colors.black,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  'Max',
                                  style: STStyles.body2Bold,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (showSwopButton) ...[
                    GestureDetector(
                      onTap: onSwap,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: colors.gray2,
                          shape: const OvalBorder(),
                        ),
                        alignment: Alignment.center,
                        child: Assets.svg.medium.change.simpleSvg(
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (optionText != null && optionOnTap != null) ...[
            const SizedBox(height: 20),
            SafeGesture(
              onTap: optionOnTap,
              child: Text(
                optionText ?? '',
                style: STStyles.subtitle2.copyWith(
                  color: colors.blue,
                ),
              ),
            ),
          ] else if (errorText != null) ...[
            const SizedBox(height: 8),
            _ErrorWidget(
              errorText: errorText!,
            ),
          ] else ...[
            const SizedBox(height: 28),
          ],
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.errorText,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 2),
          child: Assets.svg.small.warning.simpleSvg(color: colors.red),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            errorText,
            style: STStyles.body2Medium.copyWith(
              color: colors.red,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
