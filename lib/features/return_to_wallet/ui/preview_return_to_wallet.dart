import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_input.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_union.dart';
import 'package:jetwallet/features/return_to_wallet/store/preview_return_to_wallet_store.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'PreviewReturnToWalletRouter')
class PreviewReturnToWallet extends StatelessWidget {
  const PreviewReturnToWallet({
    super.key,
    required this.input,
  });

  final PreviewReturnToWalletInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewReturnToWalletStore>(
      create: (_) => PreviewReturnToWalletStore(input),
      builder: (context, child) => _PreviewReturnToWalletBody(
        input: input,
      ),
    );
  }
}

class _PreviewReturnToWalletBody extends StatefulObserverWidget {
  const _PreviewReturnToWalletBody({
    required this.input,
  });

  final PreviewReturnToWalletInput input;

  @override
  State<_PreviewReturnToWalletBody> createState() =>
      __PreviewReturnToWalletBodyState();
}

class __PreviewReturnToWalletBodyState
    extends State<_PreviewReturnToWalletBody> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final loader = StackLoaderStore();

    final store = PreviewReturnToWalletStore.of(context);

    final from = widget.input.fromCurrency;

    if (store.union is ExecuteLoading) {
      loader.startLoading();
    } else {
      if (loader.loading) {
        loader.finishLoading();
      }
    }

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: loader,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: intl.preview_return_to_wallet_return_to_wallet,
          );
        },
        medium: () {
          return SMegaHeader(
            title: intl.preview_return_to_wallet_return_to_wallet,
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH8(),
                Center(
                  child: SActionConfirmIconWithAnimation(
                    iconUrl: widget.input.fromCurrency.iconUrl,
                  ),
                ),
                const Spacer(),
                SActionConfirmText(
                  name: intl.preview_return_to_wallet_amount_to_return,
                  baseline: deviceSize.when(
                    small: () => 29,
                    medium: () => 40,
                  ),
                  value: volumeFormat(
                    prefix: from.prefixSymbol,
                    accuracy: from.accuracy,
                    decimal: Decimal.parse(widget.input.amount),
                    symbol: from.symbol,
                  ),
                ),
                SActionConfirmText(
                  name: intl.preview_return_to_wallet_remaining_balance,
                  baseline: 35.0,
                  value: volumeFormat(
                    prefix: from.prefixSymbol,
                    accuracy: from.accuracy,
                    decimal: Decimal.parse(widget.input.remainingBalance),
                    symbol: from.symbol,
                  ),
                ),
                if (widget.input.earnOffer.endDate != null)
                  SActionConfirmText(
                    name: intl.preview_return_to_wallet_expiry_date,
                    baseline: 35.0,
                    value: formatDateToDMonthYFromDate(
                      widget.input.earnOffer.endDate!,
                    ),
                  )
                else
                  SActionConfirmText(
                    name: intl.preview_return_to_wallet_term,
                    baseline: 35.0,
                    value: widget.input.earnOffer.title,
                  ),
                const SpaceH36(),
                SActionConfirmAlert(
                  alert: intl.preview_return_to_wallet_alert,
                ),
                deviceSize.when(
                  small: () => const SpaceH37(),
                  medium: () => const SpaceH16(),
                ),
                SPrimaryButton2(
                  active: store.union is QuoteSuccess,
                  name: intl.preview_return_to_wallet_confirm,
                  onTap: () {
                    store.earnOfferWithdrawal(
                      widget.input.earnOffer.offerId,
                    );
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
