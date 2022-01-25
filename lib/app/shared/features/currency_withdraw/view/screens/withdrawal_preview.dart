import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/short_address_form.dart';
import '../../helper/user_will_receive.dart';
import '../../model/withdrawal_model.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_notipod.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_state.dart';

class WithdrawalPreview extends HookWidget {
  const WithdrawalPreview({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(withdrawalPreviewNotipod(withdrawal));
    final notifier = useProvider(withdrawalPreviewNotipod(withdrawal).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

    final currency = withdrawal.currency;
    final verb = withdrawal.dictionary.verb;

    return ProviderListener<WithdrawalPreviewState>(
      provider: withdrawalPreviewNotipod(withdrawal),
      onChange: (_, state) {
        if (state.loading) {
          loader.value.startLoading();
        } else {
          loader.value.finishLoading();
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: SMegaHeader(
          title: 'Confirm $verb ${currency.description}',
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
                    name: '$verb to',
                    value: shortAddressForm(state.address),
                  ),
                  SActionConfirmText(
                    name: 'You will receive',
                    baseline: 36.0,
                    value: userWillreceive(
                      currency: currency,
                      amount: state.amount,
                      addressIsInternal: state.addressIsInternal,
                    ),
                  ),
                  SActionConfirmText(
                    name: 'Fee',
                    baseline: 35.0,
                    value: state.addressIsInternal
                        ? 'No fee'
                        : currency.withdrawalFeeWithSymbol,
                  ),
                  const SBaselineChild(
                    baseline: 34.0,
                    child: SDivider(),
                  ),
                  SActionConfirmText(
                    name: 'Total',
                    value: '${state.amount} ${currency.symbol}',
                    valueColor: colors.blue,
                  ),
                  const SpaceH36(),
                  SPrimaryButton2(
                    active: !state.loading,
                    name: 'Confirm',
                    onTap: () => notifier.withdraw(),
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
