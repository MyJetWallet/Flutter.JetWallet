import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/helper/user_will_receive.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../pin_screen/model/pin_flow_union.dart';

@RoutePage(name: 'WithdrawalPreviewRouter')
class WithdrawalPreviewScreen extends StatelessObserverWidget {
  const WithdrawalPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = WithdrawalStore.of(context);

    final matic = currencyFrom(
      sSignalRModules.currenciesList,
      store.nftInfo?.feeAssetSymbol ?? 'MATIC',
    );

    final verb = intl.withdrawal_send_verb;

    final isUserEnoughMaticForWithdraw =
        store.withdrawalType != WithdrawalType.nft ||
            matic.assetBalance > (store.nftInfo?.feeAmount ?? Decimal.zero);

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: store.previewLoader,
      customLoader: store.withdrawalType == WithdrawalType.nft
          ? store.previewIsProcessing
              ? WaitingScreen(
                  onSkip: () {},
                )
              : null
          : null,
      header: SSmallHeader(
        titleAlign: TextAlign.start,
        title: '',
        onBackButtonTap: () {
          sRouter.back();
        },
      ),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              bottom: 160,
            ),
            children: [
              deviceSize.when(
                small: () => const SpaceH8(),
                medium: () => const SpaceH24(),
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
                  ],
                ),
              ),
              deviceSize.when(
                small: () => const SpaceH36(),
                medium: () => const SpaceH56(),
              ),
              SActionConfirmText(
                name: '$verb ${intl.to}',
                value: shortAddressForm(store.address),
              ),
              SActionConfirmText(
                name: intl.cryptoDeposit_network,
                baseline: 36.0,
                value: store.networkController.text,
              ),
              SActionConfirmText(
                name: intl.withdrawalPreview_total,
                baseline: 36.0,
                value:
                    '''${store.withAmount} ${store.withdrawalType == WithdrawalType.asset ? store.withdrawalInputModel!.currency!.symbol : store.withdrawalInputModel!.nft!.name}''',
              ),
              SActionConfirmText(
                name: intl.fee,
                baseline: 35.0,
                value: store.addressIsInternal
                    ? intl.noFee
                    : store.withdrawalInputModel!.currency!
                        .withdrawalFeeWithSymbol(
                        store.networkController.text,
                      ),
              ),
              const SBaselineChild(
                baseline: 34.0,
                child: SDivider(),
              ),
              SActionConfirmText(
                name: intl.withdrawalPreview_receiverAmount,
                baseline: 36.0,
                value: userWillreceive(
                  currency: store.withdrawalInputModel!.currency!,
                  amount: store.addressIsInternal
                      ? store.withAmount
                      : (Decimal.parse(store.withAmount) -
                              store.withdrawalInputModel!.currency!
                                  .withdrawalFeeSize(
                                store.networkController.text,
                              ))
                          .toString(),
                  addressIsInternal: store.addressIsInternal,
                  network: store.networkController.text,
                ),
                valueColor: colors.blue,
              ),
              const SpaceH34(),
            ],
          ),
          SFloatingButtonFrame(
            hidePadding: true,
            button: Column(
              children: [
                const SpaceH42(),
                SPrimaryButton2(
                  active: !store.previewLoading && isUserEnoughMaticForWithdraw,
                  name: intl.withdrawalPreview_confirm,
                  onTap: () {
                    sRouter.push(
                      PinScreenRoute(
                        union: const Change(),
                        isChangePhone: true,
                        onChangePhone: (String newPin) {
                          sRouter.pop();
                          store.withdraw(newPin: newPin);
                        },
                      ),
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
