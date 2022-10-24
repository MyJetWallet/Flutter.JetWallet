import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_amount_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_preview_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
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

    final loader = StackLoaderStore();

    final currency = withdrawal.currency;
    final verb = withdrawal.dictionary.verb;

    if (store.loading) {
      loader.startLoading();
    } else {
      loader.finishLoading();
    }

    return SPageFrameWithPadding(
      loading: loader,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: '${intl.withdrawalPreview_confirm} $verb'
                ' ${currency!.description}',
          );
        },
        medium: () {
          return SMegaHeader(
            title: '${intl.withdrawalPreview_confirm} $verb'
                ' ${currency!.description}',
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
                  iconUrl: currency!.iconUrl,
                ),
                const Spacer(),
                SActionConfirmText(
                  name: '$verb ${intl.to}',
                  value: shortAddressForm(store.address),
                ),
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
                SActionConfirmText(
                  name: intl.fee,
                  baseline: 35.0,
                  value: store.addressIsInternal
                      ? intl.noFee
                      : currency.withdrawalFeeWithSymbol(network),
                ),
                const SBaselineChild(
                  baseline: 34.0,
                  child: SDivider(),
                ),
                SActionConfirmText(
                  name: intl.withdrawalPreview_total,
                  value: '${store.amount} ${currency.symbol}',
                  valueColor: colors.blue,
                ),
                const SpaceH36(),
                SPrimaryButton2(
                  active: !store.loading,
                  name: intl.withdrawalPreview_confirm,
                  onTap: () {
                    sAnalytics.sendConfirm(
                      currency: currency.symbol,
                      amount: store.amount,
                      type: 'By wallet',
                    );

                    store.withdraw();
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
