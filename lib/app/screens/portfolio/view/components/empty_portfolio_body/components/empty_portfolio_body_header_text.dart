import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyPortfolioBodyHeaderText extends HookWidget {
  const EmptyPortfolioBodyHeaderText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Get free crypto with every trade',
            style: sTextH3Style.copyWith(
              color: colors.black,
            ),
          ),
          TextSpan(
            text: ' over \$10',
            style: sTextH3Style.copyWith(
              color: colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
