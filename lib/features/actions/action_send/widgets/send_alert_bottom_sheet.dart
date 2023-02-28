import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../utils/constants.dart';
import '../../action_buy/action_buy.dart';

void sendAlertBottomSheet(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _SendAlertBottomSheet()],
  );
}

class _SendAlertBottomSheet extends StatelessObserverWidget {
  const _SendAlertBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;

    return SPaddingH24(
      child: Column(
        children: [
          Image.asset(
            sendAlertAsset,
            height: 80,
            width: 80,
          ),
          const SpaceH32(),
          Text(
            intl.sendAlert_description,
            style: sTextH3Style.copyWith(
              color: colors.black,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SpaceH15(),
          Text(
            intl.sendAlert_buyText,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 2,
          ),
          const SpaceH32(),
          SPrimaryButton1(
            active: true,
            name: intl.sendAlert_buyButton,
            onTap: () {
              showBuyAction(
                context: context,
                fromCard: true,
              );
            },
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
