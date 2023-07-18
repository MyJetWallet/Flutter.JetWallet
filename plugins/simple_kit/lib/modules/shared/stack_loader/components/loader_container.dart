import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/stack_loader/components/loader_spinner.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class LoaderContainer extends StatelessWidget {
  const LoaderContainer({
    Key? key,
    this.loadingText,
  }) : super(key: key);

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 180.0,
      height: 90.0,
      child: Container(
        width: 180.0,
        height: 90.0,
        decoration: BoxDecoration(
          color: SColorsLight().white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoaderSpinner(),
            Baseline(
              baseline: 20.6,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                loadingText != null
                    ? loadingText!.isNotEmpty
                        ? '${loadingText!} ...'
                        : 'Please wait ...'
                    : 'Please wait ...',
                style: sBodyText2Style.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
