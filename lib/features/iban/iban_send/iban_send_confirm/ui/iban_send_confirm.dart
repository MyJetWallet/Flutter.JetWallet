import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_confirm/store/iban_send_confirm_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';

@RoutePage(name: 'IbanSendConfirmRouter')
class IbanSendConfirm extends StatelessWidget {
  const IbanSendConfirm({
    super.key,
    required this.contact,
    required this.data,
  });

  final AddressBookContactModel contact;
  final IbanPreviewWithdrawalModel data;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendConfirmStore>(
      create: (context) => IbanSendConfirmStore(),
      builder: (context, child) => IbanSendConfirmBody(
        contact: contact,
        data: data,
      ),
    );
  }
}

class IbanSendConfirmBody extends StatelessObserverWidget {
  const IbanSendConfirmBody({
    super.key,
    required this.contact,
    required this.data,
  });

  final AddressBookContactModel contact;
  final IbanPreviewWithdrawalModel data;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = IbanSendConfirmStore.of(context);

    return SPageFrameWithPadding(
      loading: state.loader,
      customLoader: WaitingScreen(
        onSkip: () {},
      ),
      header: const SSmallHeader(
        isShortVersion: false,
        title: '',
      ),
      child: Stack(
        children: [
          ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: widgetSizeFrom(deviceSize) == SWidgetSize.small
                  ? 310.0
                  : 260.0,
            ),
            children: [
              Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          disclaimerAsset,
                          width: 80,
                          height: 80,
                        ),
                        const SpaceH16(),
                        Text(
                          intl.previewBuy_orderSummary,
                          style: sTextH5Style,
                        ),
                        const SpaceH34(),
                      ],
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_label,
                    value: contact.name ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_iban,
                    value: data.iban ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_bic,
                    value: data.bic ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_you_send,
                    value: volumeFormat(
                      prefix: state.eurCurrency.prefixSymbol,
                      decimal: data.sendAmount ?? Decimal.zero,
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_fee,
                    value: volumeFormat(
                      prefix: state.eurCurrency.prefixSymbol,
                      decimal: data.feeAmount ?? Decimal.zero,
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  const SpaceH17(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intl.iban_out_descr_1,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey3,
                          ),
                        ),
                        Text(
                          intl.iban_out_descr_2,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey3,
                          ),
                        ),
                        Text(
                          intl.iban_out_descr_3,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceH15(),
                  deviceSize.when(
                    small: () {
                      return const SizedBox();
                    },
                    medium: () {
                      return Column(
                        children: [
                          const SDivider(),
                          SActionConfirmText(
                            name: intl.iban_out_total,
                            contentLoading: state.loader.loading,
                            valueColor: colors.blue,
                            value: volumeFormat(
                              prefix: state.eurCurrency.prefixSymbol,
                              decimal: data.amount ?? Decimal.zero,
                              accuracy: state.eurCurrency.accuracy,
                              symbol: state.eurCurrency.symbol,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SpaceH20(),
                ],
              ),
            ],
          ),
          SFloatingButtonFrame(
            hidePadding: true,
            button: Column(
              children: [
                const SpaceH20(),
                const SpaceH24(),
                SPrimaryButton2(
                  active: true,
                  name: intl.previewBuyWithAsset_confirm,
                  onTap: () {
                    state.confirmIbanOut(
                      data,
                      contact,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
