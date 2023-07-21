import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/device_size/device_size.dart';
import '../../../utils/helpers/string_helper.dart';
import '../../../utils/helpers/widget_size_from.dart';
import '../widgets/gift_send_type.dart';

@RoutePage(name: 'GiftAmountRouter')
class GiftAmount extends StatelessWidget {
  const GiftAmount({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Send Gift',
          subTitle: 'Available: 3 000 USDT',
          subTitleStyle: TextStyle(
            color: Color(0xFF777C85),
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      child: Column(
        children: [
          const SpaceH46(),
          SActionPriceField(
            widgetSize: widgetSizeFrom(deviceSize),
            price: formatCurrencyStringAmount(
              value: '200',
              symbol: 'USDT',
            ),
            helper: '',
            error: 'Enter smaller amount. Max 2 000 USDT',
            isErrorActive: false,
          ),
          const Spacer(),
          const GiftSendType(),
          const SpaceH20(),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: '100%',
            selectedPreset: null,
            onPresetChanged: (preset) {},
            onKeyPressed: (value) {},
            buttonType: SButtonType.primary2,
            submitButtonActive: true,
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {
              sRouter.push(
                const GiftOrderSummuryRouter(),
              );
            },
          ),
        ],
      ),
    );
  }
}
