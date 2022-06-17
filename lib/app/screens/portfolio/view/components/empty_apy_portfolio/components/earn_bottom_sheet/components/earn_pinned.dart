import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../../../../../../../shared/constants.dart';
import '../../../../../../../../../shared/providers/device_size/media_query_pod.dart';
import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_body_header.dart';

class EarnPinned extends HookWidget {
  const EarnPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final colors = useProvider(sColorPod);
    final mediaQuery = useProvider(mediaQueryPod);

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
              top: 24.0,
              right: 24.0,
              child: SIconButton(
                onTap: () => Navigator.pop(context),
                defaultIcon: const SEraseMarketIcon(),
                pressedIcon: const SErasePressedIcon(),
              ),
            ),
            Positioned(
              width: mediaQuery.size.width,
              top: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35.0,
                    height: 4.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SpaceH33(),
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
