import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/withdrawal_model.dart';
import '../notifier/withdrawal_address_notifier/address_validation_union.dart';
import '../notifier/withdrawal_address_notifier/withdrawal_address_notipod.dart';

/// FLOW: WithdrawalAmount -> WithdrawalPreview -> WithdrawalConfirm
class CurrencyWithdraw extends HookWidget {
  const CurrencyWithdraw({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(withdrawalAddressNotipod(withdrawal));
    final notifier = useProvider(withdrawalAddressNotipod(withdrawal).notifier);
    useValueListenable(state.addressErrorNotifier!);
    useValueListenable(state.tagErrorNotifier!);

    final currency = withdrawal.currency;

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: '${withdrawal.dictionary.verb} ${currency.description}',
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Material(
                  color: colors.white,
                  child: SPaddingH24(
                    child: SStandardField(
                      errorNotifier: state.addressErrorNotifier,
                      labelText: 'Enter ${currency.symbol} address',
                      focusNode: state.addressFocus,
                      controller: state.addressController,
                      onChanged: (value) => notifier.updateAddress(value),
                      onErase: () => notifier.eraseAddress(),
                      suffixIcons: [
                        SIconButton(
                          onTap: () => notifier.pasteAddress(),
                          defaultIcon: const SPasteIcon(),
                        ),
                        SIconButton(
                          onTap: () => notifier.scanAddressQr(context),
                          defaultIcon: const SQrCodeIcon(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (currency.hasTag) ...[
                  Material(
                    color: colors.white,
                    child: SPaddingH24(
                      child: SStandardField(
                        errorNotifier: state.tagErrorNotifier,
                        labelText: 'Enter Tag',
                        focusNode: state.tagFocus,
                        controller: state.tagController,
                        onChanged: (value) => notifier.updateTag(value),
                        onErase: () => notifier.eraseTag(),
                        suffixIcons: [
                          SIconButton(
                            onTap: () => notifier.pasteTag(),
                            defaultIcon: const SPasteIcon(),
                          ),
                          SIconButton(
                            onTap: () => notifier.scanTagQr(context),
                            defaultIcon: const SQrCodeIcon(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (state.addressValidation is! Hide) ...[
                  const SpaceH20(),
                  SPaddingH24(
                    child: SRequirement(
                      isError: state.isRequirementError,
                      loading: state.requirementLoading,
                      description: state.validationResult,
                      // error and loading goes first in the RRequirement
                      // condition, if not Error or Loading then
                      // it's always passed
                      passed: true,
                    ),
                  ),
                ],
                SPaddingH24(
                  child: Baseline(
                    baseline: 32.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      state.withdrawHint,
                      maxLines: 3,
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ),
                ),
                const SpaceH100(),
              ],
            ),
          ),
          Column(
            children: [
              const Spacer(),
              SPaddingH24(
                child: Material(
                  child: SPrimaryButton2(
                    active: state.isReadyToContinue,
                    name: 'Continue',
                    onTap: () => notifier.validateOnContinue(context),
                  ),
                ),
              ),
              const SpaceH24(),
            ],
          )
        ],
      ),
    );
  }
}
