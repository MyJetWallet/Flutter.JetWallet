import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import 'components/empty_wallet_balance_text.dart';

class EmptyWalletBody extends HookWidget {
  const EmptyWalletBody({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);

    return Column(
      children: [
        deviceSize.when(
          small: () {
            return EmptyWalletBalanceText(
              height: 128,
              baseline: 115,
              color: colors.black,
            );
          },
          medium: () {
            return EmptyWalletBalanceText(
              height: 184,
              baseline: 171,
              color: colors.black,
            );
          },
        ),
        const Spacer(),
        Text(
          'All $assetName transaction',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: sTextH3Style,
        ),
        const SpaceH13(),
        Text(
          'Your transactions will appear here',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
