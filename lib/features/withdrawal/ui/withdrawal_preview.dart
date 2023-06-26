import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/helper/user_will_receive.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';

@RoutePage(name: 'WithdrawalPreviewRouter')
class WithdrawalPreviewScreen extends StatelessObserverWidget {
  const WithdrawalPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = WithdrawalStore.of(context);

    final baseCurrency = sSignalRModules.baseCurrency;

    final matic = currencyFrom(
      sSignalRModules.currenciesList,
      store.nftInfo?.feeAssetSymbol ?? 'MATIC',
    );

    final descr = store.withdrawalType == WithdrawalType.Asset
        ? store.withdrawalInputModel!.currency!.description
        : store.withdrawalInputModel!.nft!.name;
    final verb = store.withdrawalInputModel!.dictionary.verb;

    final title = store.withdrawalType == WithdrawalType.Asset
        ? '${intl.withdrawalPreview_confirm} $verb'
            ' $descr'
        : '${intl.nft_send} ${store.withdrawalInputModel!.nft!.name}';

    final isUserEnoughMaticForWithdraw =
        store.withdrawalType == WithdrawalType.NFT
            ? matic.assetBalance > (store.nftInfo?.feeAmount ?? Decimal.zero)
            : true;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: store.previewLoader,
      customLoader: store.withdrawalType == WithdrawalType.NFT
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
                    '${store.withAmount} ${store.withdrawalType == WithdrawalType.Asset ? store.withdrawalInputModel!.currency!.symbol : store.withdrawalInputModel!.nft!.name}',
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
              if (!isUserEnoughMaticForWithdraw) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.grey4,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SInfoIcon(
                        color: colors.red,
                      ),
                      const SpaceW12(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          '${intl.nft_send_not_enough_1} ${store.withdrawalType == WithdrawalType.Asset ? store.withdrawalInputModel!.currency!.symbol : store.nftInfo?.feeAssetSymbol} ${intl.nft_send_not_enough_2}',
                          style: sBodyText1Style,
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                    store.withdraw();
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
