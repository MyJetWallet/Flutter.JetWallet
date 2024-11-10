import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/page_frame/components/loader_spinner.dart';

class LoaderContainer extends StatelessWidget {
  const LoaderContainer({
    super.key,
    required this.loadingText,
  });

  final String loadingText;

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
                loadingText,
                style: STStyles.body2Medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
