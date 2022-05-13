import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../components/network_bottom_sheet/show_network_bottom_sheet.dart';
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
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(withdrawalAddressNotipod(withdrawal));
    final notifier = useProvider(withdrawalAddressNotipod(withdrawal).notifier);
    final _scrollController = useScrollController();
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
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Material(
                  color: colors.white,
                  child: InkWell(
                    highlightColor: colors.grey5,
                    splashColor: Colors.transparent,
                    onTap: () {
                      showNetworkBottomSheet(
                        context,
                        state.network,
                        currency.withdrawalBlockchains,
                        currency.iconUrl,
                        notifier.updateNetwork,
                      );
                    },
                    child: SPaddingH24(
                      child: SStandardField(
                        controller: state.networkController,
                        labelText: intl.showNetwork_header1,
                        enabled: false,
                        hideIconsIfNotEmpty: false,
                        hideClearButton: true,
                        suffixIcons: const [
                          SAngleDownIcon(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SDivider(),
                Material(
                  color: colors.white,
                  child: SPaddingH24(
                    child: SStandardField(
                      errorNotifier: state.addressErrorNotifier,
                      labelText: '${intl.enter} ${currency.symbol} ${intl.address1}',
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
                if (state.network.tagType == TagType.tag ||
                    state.network.tagType == TagType.memo) ...[
                  const SDivider(),
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
                  const SpaceH10(),
                ],
                const SpaceH10(),
                SPaddingH24(
                  child: Text(
                    state.withdrawHint,
                    maxLines: 3,
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
                const Spacer(),
                const SpaceH19(),
                SPaddingH24(
                  child: Material(
                    color: colors.grey5,
                    child: SPrimaryButton2(
                      active: state.isReadyToContinue,
                      name: intl.continueText,
                      onTap: () => notifier.validateOnContinue(context),
                    ),
                  ),
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
