import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../../../../../../../shared/constants.dart';
import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_body_header.dart';

class EarnPinned extends HookWidget {
  const EarnPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final colors = useProvider(sColorPod);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    earnGroupImageAsset,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 33.0,
              right: 26.0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SEraseMarketIcon(),
              ),
            ),
          ],
        ),
        const SpaceH30(),
        SPaddingH24(
          child: EarnBodyHeader(
            currencies: currencies,
            colors: colors,
          ),
        ),
      ],
    );
  }
}
