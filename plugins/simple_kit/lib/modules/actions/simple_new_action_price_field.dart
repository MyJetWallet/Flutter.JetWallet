import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SNewActionPriceField extends StatelessWidget {
  const SNewActionPriceField({
    super.key,
    required this.primaryAmount,
    required this.primarySymbol,
    this.secondaryAmount,
    this.secondarySymbol,
    required this.widgetSize,
    required this.onSwap,
    this.errorText,
    this.optionText,
    this.optionOnTap,
    required this.pasteLabel,
    required this.onPaste,
    this.showSwopButton = true,
  });

  final String primaryAmount;
  final String primarySymbol;
  final String? secondaryAmount;
  final String? secondarySymbol;
  final void Function()? onSwap;
  final String? errorText;
  final SWidgetSize widgetSize;
  final String? optionText;
  final Function()? optionOnTap;
  final String pasteLabel;
  final VoidCallback onPaste;
  final bool showSwopButton;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: SizedBox(
        height: 117,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              children: [
                                AutoSizeText(
                                  primaryAmount,
                                  maxLines: 1,
                                  style: sTextH0Style.copyWith(
                                    color: primaryAmount == '0' ? colors.grey3 : colors.black,
                                    height: 0.8,
                                  ),
                                ),
                                AutoSizeText(
                                  ' $primarySymbol',
                                  maxLines: 1,
                                  style: sTextH2Style.copyWith(
                                    color: primaryAmount == '0' ? colors.grey3 : colors.black,
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
                            child: AutoSizeText(
                              '$primaryAmount $primarySymbol',
                              maxLines: 1,
                              style: sTextH3Style.copyWith(
                                color: primaryAmount == '0' ? colors.grey3 : colors.black,
                              ),
                            ),
                          ),
                        ),
                      const SpaceH4(),
                      if (secondaryAmount != null)
                        AutoSizeText(
                          '$secondaryAmount $secondarySymbol',
                          minFontSize: 4.0,
                          maxLines: 1,
                          style: sSubtitle3Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showSwopButton) ...[
                  const SpaceW24(),
                  SIconButton(
                    onTap: onSwap,
                    defaultIcon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.grey5,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      margin: const EdgeInsets.only(right: 27),
                      child: SSwapIcon(
                        color: colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (optionText != null && optionOnTap != null) ...[
              const SpaceH20(),
              SClickableLinkText(
                text: optionText!,
                onTap: optionOnTap!,
              ),
            ] else if (errorText != null) ...[
              const SpaceH8(),
              _ErrorWidget(
                errorText: errorText!,
              ),
            ] else ...[
              const SpaceH28(),
            ],
          ],
        ),
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
    final colors = sKit.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 2),
          child: const SErrorIcon(),
        ),
        const SpaceW5(),
        Expanded(
          child: Text(
            errorText,
            style: sBodyText2Style.copyWith(
              color: colors.red,
              height: 1.4,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
