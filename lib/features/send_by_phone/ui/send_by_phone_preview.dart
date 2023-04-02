import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_amount_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_preview_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SendByPhonePreviewRouter')
class SendByPhonePreview extends StatelessWidget {
  const SendByPhonePreview({
    super.key,
    required this.currency,
    required this.amountStoreAmount,
    required this.pickedContact,
    required this.activeDialCode,
  });

  final CurrencyModel currency;
  final String amountStoreAmount;
  final ContactModel pickedContact;
  final SPhoneNumber activeDialCode;

  @override
  Widget build(BuildContext context) {
    return Provider<SendByPreviewStore>(
      create: (context) => SendByPreviewStore(
        currency,
        amountStoreAmount,
        pickedContact,
        activeDialCode,
      ),
      builder: (context, child) => _SendByPhonePreviewBody(
        currency: currency,
      ),
    );
  }
}

class _SendByPhonePreviewBody extends StatelessObserverWidget {
  const _SendByPhonePreviewBody({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = SendByPreviewStore.of(context);

    if (state.loading) {
      state.loader.startLoading();
    } else {
      state.loader.finishLoading();
    }

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: state.loader,
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
