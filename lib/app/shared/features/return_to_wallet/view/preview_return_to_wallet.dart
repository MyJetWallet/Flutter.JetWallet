import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../wallet/helper/format_date_to_hm.dart';
import '../model/preview_return_to_wallet_input.dart';
import '../notifier/preview_return_to_wallet_notifier/preview_return_to_wallet_notipod.dart';
import '../notifier/preview_return_to_wallet_notifier/preview_return_to_wallet_state.dart';
import '../notifier/preview_return_to_wallet_notifier/preview_return_to_wallet_union.dart';

class PreviewReturnToWallet extends StatefulHookWidget {
  const PreviewReturnToWallet({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewReturnToWalletInput input;

  @override
  State<PreviewReturnToWallet> createState() => _PreviewReturnToWallet();
}

class _PreviewReturnToWallet extends State<PreviewReturnToWallet> {
  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final deviceSize = useProvider(deviceSizePod);
    final notifier =
        useProvider(previewReturnToWalletNotipod(widget.input).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

    final from = widget.input.fromCurrency;

    return ProviderListener<PreviewReturnToWalletState>(
      provider: previewReturnToWalletNotipod(widget.input),
      onChange: (_, value) {
        if (value.union is ExecuteLoading) {
          loader.value.startLoading();
        } else {
          if (loader.value.value) {
            loader.value.finishLoading();
          }
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
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
                    active: true,
                    name: intl.preview_return_to_wallet_confirm,
                    onTap: () {
                      notifier.earnOfferWithdrawal(
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
      ),
    );
  }
}
