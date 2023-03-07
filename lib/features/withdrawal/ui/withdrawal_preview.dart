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
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';

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
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            titleAlign: store.withdrawalType == WithdrawalType.NFT
                ? TextAlign.center
                : TextAlign.start,
            title: title,
            onBackButtonTap: () {

              sRouter.navigateBack();
            },
          );
        },
        medium: () {
          return SMegaHeader(
            titleAlign: store.withdrawalType == WithdrawalType.NFT
                ? TextAlign.center
                : TextAlign.start,
            crossAxisAlignment: store.withdrawalType == WithdrawalType.NFT
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            title: title,
            onBackButtonTap: () {

              sRouter.navigateBack();
            },
          );
        },
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const SpaceH24(),
                if (store.withdrawalType == WithdrawalType.Asset) ...[
                  SActionConfirmIconWithAnimation(
                    iconUrl: store.withdrawalInputModel!.currency!.iconUrl,
                  ),
                ] else ...[
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(
                          '$shortUrl${store.withdrawalInputModel!.nft!.sImage}',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                SActionConfirmText(
                  name: '$verb ${intl.to}',
                  value: shortAddressForm(store.address),
                ),
                if (store.withdrawalType == WithdrawalType.Asset) ...[
                  SActionConfirmText(
                    name: intl.cryptoDeposit_network,
                    baseline: 36.0,
                    value: store.networkController.text,
                  ),
                  SActionConfirmText(
                    name: intl.withdrawalPreview_youWillSend,
                    baseline: 36.0,
                    value: userWillreceive(
                      currency: store.withdrawalInputModel!.currency!,
                      amount: store.withAmount,
                      addressIsInternal: store.addressIsInternal,
                      network: store.networkController.text,
                    ),
                  ),
                ],
                SActionConfirmText(
                  name: intl.fee,
                  baseline: 35.0,
                  value: store.withdrawalType == WithdrawalType.Asset
                      ? store.addressIsInternal
                          ? intl.noFee
                          : store.withdrawalInputModel!.currency!
                              .withdrawalFeeWithSymbol(
                              store.networkController.text,
                            )
                      : store.nftInfo?.feeAmount == Decimal.zero
                          ? intl.noFee
                          : '${store.nftInfo?.feeAmount} ${store.nftInfo?.feeAssetSymbol}',
                ),
                const SBaselineChild(
                  baseline: 34.0,
                  child: SDivider(),
                ),
                if (store.withdrawalType == WithdrawalType.Asset) ...[
                  SActionConfirmText(
                    name: intl.withdrawalPreview_total,
                    value:
                        '${store.withAmount} ${store.withdrawalType == WithdrawalType.Asset ? store.withdrawalInputModel!.currency!.symbol : store.withdrawalInputModel!.nft!.name}',
                    valueColor: colors.blue,
                  ),
                ] else ...[
                  SActionConfirmText(
                    name: intl.withdrawalPreview_total,
                    value: volumeFormat(
                      accuracy: matic.accuracy,
                      decimal: store.nftInfo?.feeAmount ?? Decimal.zero,
                      symbol: matic.symbol,
                    ),
                    valueDescription: volumeFormat(
                      prefix: baseCurrency.prefix,
                      decimal: matic.currentPrice *
                          (store.nftInfo?.feeAmount ?? Decimal.zero),
                      symbol: baseCurrency.symbol,
                      accuracy: 6,
                    ),
                    valueColor: colors.blue,
                  ),
                ],
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
                const SpaceH16(),
                SPrimaryButton2(
                  active: !store.previewLoading && isUserEnoughMaticForWithdraw,
                  name: intl.withdrawalPreview_confirm,
                  onTap: () {
                    if (store.withdrawalType == WithdrawalType.Asset) {

                      store.withdraw();
                    } else {

                      //store.withdrawNFT();

                      store.previewConfirm();
                    }
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
