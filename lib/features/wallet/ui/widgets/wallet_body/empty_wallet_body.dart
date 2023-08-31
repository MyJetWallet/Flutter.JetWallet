import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/empty_wallet_balance_text.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyWalletBody extends StatelessObserverWidget {
  const EmptyWalletBody({
    super.key,
    required this.assetName,
  });

  final String assetName;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = getIt.get<DeviceSize>().size;

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
          '${intl.emptyWalletBody_all} ${assetName.toLowerCase()} ${intl.transactions}',
          maxLines: 3,
          textAlign: TextAlign.center,
          style: sTextH3Style,
        ),
        const SpaceH13(),
        Text(
          '',
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
