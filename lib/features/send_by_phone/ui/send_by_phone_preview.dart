import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_preview_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

class SendByPhonePreview extends StatelessObserverWidget {
  const SendByPhonePreview({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = SendByPreviewStore(currency);

    final loader = StackLoaderStore();

    if (state.loading) {
      loader.startLoading();
    } else {
      loader.finishLoading();
    }

    return SPageFrameWithPadding(
      loading: loader,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: '${intl.sendByPhonePreview_send} ${currency.description}'
                ' ${intl.sendByPhonePreview_byPhone}',
          );
        },
        medium: () {
          return SMegaHeader(
            title: '${intl.sendByPhonePreview_send} ${currency.description}'
                ' ${intl.sendByPhonePreview_byPhone}',
          );
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SActionConfirmIconWithAnimation(
                  iconUrl: currency.iconUrl,
                ),
                const Spacer(),
                SActionConfirmText(
                  name: intl.sendByPhonePreview_youSendTo,
                  value: state.pickedContact!.phoneNumber,
                  valueDescription: state.pickedContact!.name,
                ),
                SActionConfirmText(
                  name: intl.sendByPhonePreview_amountToSend,
                  baseline: 35.0,
                  value: volumeFormat(
                    prefix: currency.prefixSymbol,
                    accuracy: currency.accuracy,
                    decimal: Decimal.parse(state.amount),
                    symbol: currency.symbol,
                  ),
                ),
                const SpaceH35(),
                const SDivider(),
                const SpaceH4(),
                SActionConfirmText(
                  name: intl.sendByPhonePreview_total,
                  baseline: 35.0,
                  value: volumeFormat(
                    prefix: currency.prefixSymbol,
                    accuracy: currency.accuracy,
                    decimal: Decimal.parse(state.amount),
                    symbol: currency.symbol,
                  ),
                  valueColor: colors.blue,
                ),
                const SpaceH35(),
                SPrimaryButton2(
                  active: !state.loading,
                  name: intl.sendByPhonePreview_confirm,
                  onTap: () {
                    sAnalytics.sendConfirm(
                      currency: currency.symbol,
                      amount: state.amount,
                      type: 'By phone',
                    );

                    state.send();
                  },
                ),
                const SpaceH24(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
