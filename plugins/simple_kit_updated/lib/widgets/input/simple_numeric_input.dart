import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SNumericInput extends StatelessWidget {
  const SNumericInput({
    super.key,
    this.haveErrorMessage = false,
    this.errorMessage,
    this.value = '0',
    this.equivalent,
    required this.ticker,
    required this.onSwapButtonTap,
  });

  final bool haveErrorMessage;
  final String? errorMessage;

  final String value;
  final String ticker;
  final String? equivalent;

  final VoidCallback onSwapButtonTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 136,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Center(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .53,
                            ),
                            child: AutoSizeText(
                              value,
                              minFontSize: 32,
                              maxLines: 1,
                              style: STStyles.header1.copyWith(
                                color: value != '0' ? SColorsLight().black : SColorsLight().gray6,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Gap(8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              ticker,
                              style: STStyles.header3.copyWith(
                                color: value != '0' ? SColorsLight().black : SColorsLight().gray6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (equivalent != null)
                      SizedBox(
                        height: 24,
                        child: Text(
                          equivalent ?? '',
                          style: STStyles.body1Semibold.copyWith(
                            color: SColorsLight().gray10,
                          ),
                        ),
                      ),
                    if (haveErrorMessage) ...[
                      const Gap(8),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Assets.svg.small.warning.simpleSvg(
                              width: 16,
                              height: 16,
                              color: SColorsLight().red,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            errorMessage ?? '',
                            style: STStyles.body2Medium.copyWith(
                              color: SColorsLight().red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                SafeGesture(
                  onTap: onSwapButtonTap,
                  highlightColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SColorsLight().gray2,
                    ),
                    child: Assets.svg.medium.swap2.simpleSvg(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
