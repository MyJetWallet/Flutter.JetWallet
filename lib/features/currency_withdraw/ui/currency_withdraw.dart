import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/currency_withdraw/model/address_validation_union.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/widgets/network_bottom_sheet/show_network_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class CurrencyWithdraw extends StatelessWidget {
  const CurrencyWithdraw({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    return Provider<WithdrawalAddressStore>(
      create: (context) =>
          WithdrawalAddressStore()..clearDataAndInit(withdrawal),
      builder: (context, child) => _CurrencyWithdrawBody(
        withdrawal: withdrawal,
      ),
      dispose: (context, value) => value.dispose(),
    );
  }
}

/// FLOW: WithdrawalAmount -> WithdrawalPreview -> WithdrawalConfirm
class _CurrencyWithdrawBody extends StatefulObserverWidget {
  const _CurrencyWithdrawBody({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;
  @override
  State<_CurrencyWithdrawBody> createState() => __CryptoWithdrawBodyState();
}

class __CryptoWithdrawBodyState extends State<_CurrencyWithdrawBody> {
  @override
  void initState() {
    final withdraw = WithdrawalAddressStore.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.withdrawal.currency != null) {
        if (!widget.withdrawal.currency!.isSingleNetwork) {
          showNetworkBottomSheet(
            context,
            withdraw.network,
            widget.withdrawal.currency!.depositBlockchains,
            widget.withdrawal.currency!.iconUrl,
            withdraw.updateNetwork,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = WithdrawalAddressStore.of(context);

    final scrollController = ScrollController();

    //useValueListenable(state.addressErrorNotifier!);
    //useValueListenable(state.tagErrorNotifier!);

    final currency = widget.withdrawal.currency;

    final asset =
        store.currencyModel != null ? store.currencyModel!.symbol : 'Matic';

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      color: colors.grey5,
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: store.header,
          onBackButtonTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: CustomScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
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
                      if (store.currencyModel != null &&
                          store.currencyModel!.withdrawalBlockchains.length >
                              1) {
                        showNetworkBottomSheet(
                          context,
                          store.network,
                          store.currencyModel!.withdrawalBlockchains,
                          store.currencyModel!.iconUrl,
                          store.updateNetwork,
                        );
                      }
                    },
                    child: SPaddingH24(
                      child: SStandardField(
                        controller: store.networkController,
                        labelText: (store.currencyModel != null &&
                                store.currencyModel!.withdrawalBlockchains
                                        .length >
                                    1)
                            ? intl.currencyWithdraw_chooseNetwork
                            : intl.cryptoDeposit_network,
                        enabled: false,
                        hideIconsIfNotEmpty: false,
                        hideClearButton: true,
                        suffixIcons: [
                          if (store.currencyModel != null &&
                              store.currencyModel!.withdrawalBlockchains
                                      .length >
                                  1)
                            const SAngleDownIcon(),
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
                      isError: store.addressError,
                      labelText: '${intl.currencyWithdraw_enter}'
                          ' $asset '
                          '${intl.currencyWithdraw_address}',
                      focusNode: store.addressFocus,
                      controller: store.addressController,
                      onChanged: (value) {
                        store.scrollToBottom(scrollController);
                        store.updateAddress(value, validate: true);
                      },
                      onErase: () => store.eraseAddress(),
                      suffixIcons: [
                        SIconButton(
                          onTap: () => store.pasteAddress(scrollController),
                          defaultIcon: const SPasteIcon(),
                        ),
                        SIconButton(
                          onTap: () => store.scanAddressQr(
                            context,
                            scrollController,
                          ),
                          defaultIcon: const SQrCodeIcon(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (store.network.tagType == TagType.tag ||
                    store.network.tagType == TagType.memo) ...[
                  const SDivider(),
                  Material(
                    color: colors.white,
                    child: SPaddingH24(
                      child: SStandardField(
                        isError: store.tagError,
                        labelText: intl.currencyWithdraw_enterTag,
                        focusNode: store.tagFocus,
                        controller: store.tagController,
                        onChanged: (value) => store.updateTag(value),
                        onErase: () => store.eraseTag(),
                        suffixIcons: [
                          SIconButton(
                            onTap: () => store.pasteTag(scrollController),
                            defaultIcon: const SPasteIcon(),
                          ),
                          SIconButton(
                            onTap: () => store.scanTagQr(
                              context,
                              scrollController,
                            ),
                            defaultIcon: const SQrCodeIcon(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (store.addressValidation is! Hide) ...[
                  const SpaceH20(),
                  SPaddingH24(
                    child: SRequirement(
                      isError: store.isRequirementError,
                      loading: store.requirementLoading,
                      description: store.validationResult,
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
                    store.withdrawHint,
                    maxLines: 3,
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
                const Spacer(),
                const SpaceH19(),
                Observer(
                  builder: (context) {
                    return SPaddingH24(
                      child: Material(
                        color: colors.grey5,
                        child: SPrimaryButton2(
                          active: store.isReadyToContinue,
                          name: intl.currencyWithdraw_continue,
                          onTap: () {
                            store.validateOnContinue(context);
                          },
                        ),
                      ),
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
