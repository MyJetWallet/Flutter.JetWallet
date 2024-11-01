import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SActionPriceField extends StatelessWidget {
  const SActionPriceField({
    super.key,
    this.additionalWidget,
    required this.price,
    required this.helper,
    required this.error,
    required this.isErrorActive,
    required this.widgetSize,
    required this.pasteLabel,
    required this.onPaste,
    this.errorMaxLines = 1,
  });

  final String price;
  final String helper;
  final String error;
  final bool isErrorActive;
  final SWidgetSize widgetSize;
  final Widget? additionalWidget;
  final String pasteLabel;
  final VoidCallback onPaste;
  final int errorMaxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widgetSize == SWidgetSize.small ? 116 : null,
      child: Column(
        children: [
          SPaddingH24(
            child: Baseline(
              baseline: widgetSize == SWidgetSize.small ? 32 : 22,
              baselineType: TextBaseline.alphabetic,
              child: additionalWidget == null
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Theme(
                        data: ThemeData(
                          textSelectionTheme: const TextSelectionThemeData(
                            cursorColor: Colors.transparent,
                            selectionColor: Colors.transparent,
                            selectionHandleColor: Colors.transparent,
                          ),
                        ),
                        child: SelectableText(
                          price,
                          cursorColor: Colors.transparent,
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
                          maxLines: 1,
                          style: sTextH1Style.copyWith(
                            color: isErrorActive ? SColorsLight().red : SColorsLight().black,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        additionalWidget!,
                        const SpaceW8(),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Theme(
                            data: ThemeData(
                              textSelectionTheme: const TextSelectionThemeData(
                                cursorColor: Colors.transparent,
                                selectionColor: Colors.transparent,
                                selectionHandleColor: Colors.transparent,
                              ),
                            ),
                            child: SelectableText(
                              price,
                              maxLines: 1,
                              style: sTextH1Style.copyWith(
                                color: isErrorActive ? SColorsLight().red : SColorsLight().black,
                              ),
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
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SpaceH4(),
          SPaddingH24(
            child: Baseline(
              baseline: 13,
              baselineType: TextBaseline.alphabetic,
              child: AutoSizeText(
                isErrorActive ? error : helper,
                textAlign: TextAlign.center,
                minFontSize: 4.0,
                maxLines: errorMaxLines,
                strutStyle: const StrutStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  fontFamily: 'Gilroy',
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  fontFamily: 'Gilroy',
                  color: isErrorActive ? SColorsLight().red : SColorsLight().grey1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
