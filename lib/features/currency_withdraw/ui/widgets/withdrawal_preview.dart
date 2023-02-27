import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_amount_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_preview_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../helper/user_will_receive.dart';
import '../../model/withdrawal_model.dart';

class WithdrawalPreview extends StatelessWidget {
  const WithdrawalPreview({
    Key? key,
    required this.withdrawal,
    required this.network,
    required this.addressStore,
    required this.amountStore,
  }) : super(key: key);

  final WithdrawalModel withdrawal;
  final String network;
  final WithdrawalAddressStore addressStore;
  final WithdrawalAmountStore amountStore;

  @override
  Widget build(BuildContext context) {
    return Provider<WithdrawalPreviewStore>(
      create: (context) =>
          WithdrawalPreviewStore(withdrawal, amountStore, addressStore),
      builder: (context, child) => _WithdrawalPreviewBody(
        withdrawal: withdrawal,
        network: network,
      ),
    );
  }
}

class _WithdrawalPreviewBody extends StatelessObserverWidget {
  const _WithdrawalPreviewBody({
    Key? key,
    required this.withdrawal,
    required this.network,
  }) : super(key: key);

  final WithdrawalModel withdrawal;
  final String network;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = WithdrawalPreviewStore.of(context);

    final currency = withdrawal.currency;
    final verb = withdrawal.dictionary.verb;

    final baseCurrency = sSignalRModules.baseCurrency;

    final descr =
        currency != null ? currency.description : withdrawal.nft!.name;

    final btc = sSignalRModules.currenciesList
        .where((element) => element.symbol == 'BTC')
        .first;

    final matic = currencyFrom(
      sSignalRModules.currenciesList,
      'MATIC',
    );

    final title = currency != null
        ? '${intl.withdrawalPreview_confirm} $verb'
            ' $descr'
        : '${intl.nft_send} ${withdrawal.nft!.name}';

    final isUserEnoughMaticForWithdraw = currency == null
        ? matic.assetBalance > matic.withdrawalFeeSize(network)
        : true;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: store.loader,
      customLoader: currency == null
          ? store.isProcessing
              ? WaitingScreen(
                  onSkip: () {},
                )
              : null
          : null,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            titleAlign: currency != null ? TextAlign.center : TextAlign.start,
            title: title,
            onBackButtonTap: () {
              Navigator.pop(context);
            },
          );
        },
        medium: () {
          return SMegaHeader(
            titleAlign: currency != null ? TextAlign.center : TextAlign.start,
            title: title,
            onBackButtonTap: () {
              Navigator.pop(context);
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
                SActionConfirmIconWithAnimation(
                  iconUrl: currency != null ? currency.iconUrl : btc.iconUrl,
                ),
                const Spacer(),
                SActionConfirmText(
                  name: '$verb ${intl.to}',
                  value: shortAddressForm(store.address),
                ),
                SActionConfirmText(
                  name: intl.cryptoDeposit_network,
                  baseline: 36.0,
                  value: network,
                ),
                if (currency != null) ...[
                  SActionConfirmText(
                    name: intl.withdrawalPreview_youWillSend,
                    baseline: 36.0,
                    value: userWillreceive(
                      currency: currency,
                      amount: store.amount,
                      addressIsInternal: store.addressIsInternal,
                      network: network,
                    ),
                  ),
                ],
                SActionConfirmText(
                  name: intl.fee,
                  baseline: 35.0,
                  value: store.addressIsInternal
                      ? intl.noFee
                      : currency != null
                          ? currency.withdrawalFeeWithSymbol(network)
                          : matic.withdrawalFeeWithSymbol(network),
                ),
                const SBaselineChild(
                  baseline: 34.0,
                  child: SDivider(),
                ),
                if (currency != null) ...[
                  SActionConfirmText(
                    name: intl.withdrawalPreview_total,
                    value:
                        '${store.amount} ${currency != null ? currency.symbol : withdrawal.nft!.name}',
                    valueColor: colors.blue,
                  ),
                ] else ...[
                  SActionConfirmText(
                    name: intl.withdrawalPreview_total,
                    value: volumeFormat(
                      accuracy: matic.accuracy,
                      decimal: matic.withdrawalFeeSize(network),
                      symbol: matic.symbol,
                    ),
                    valueDescription: volumeFormat(
                      prefix: baseCurrency.prefix,
                      decimal:
                          matic.currentPrice * matic.withdrawalFeeSize(network),
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
                            '${intl.nft_send_not_enough_1} ${currency != null ? currency.symbol : matic.symbol} ${intl.nft_send_not_enough_2}',
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
                  active: !store.loading && isUserEnoughMaticForWithdraw,
                  name: intl.withdrawalPreview_confirm,
                  onTap: () {
                    if (currency != null) {

                      store.withdraw();
                    } else {
                      store.withdrawNFT();
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
