
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

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
  const _SendAlertBottomSheet();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
              showSendTimerAlertOr(
                context: context,
                or: () {
                  showBuyAction(
                    context: context,
                  );
                },
                from: BlockingType.deposit,
              );
            },
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
