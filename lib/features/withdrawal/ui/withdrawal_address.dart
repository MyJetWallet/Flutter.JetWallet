import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/widgets/network_bottom_sheet/show_network_bottom_sheet.dart';
import 'package:jetwallet/features/currency_withdraw/model/address_validation_union.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

@RoutePage(name: 'WithdrawalAddressRouter')
class WithdrawalAddressScreen extends StatefulObserverWidget {
  const WithdrawalAddressScreen({super.key});

  @override
  State<WithdrawalAddressScreen> createState() =>
      _WithdrawalAddressScreenState();
}

class _WithdrawalAddressScreenState extends State<WithdrawalAddressScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    final store = WithdrawalStore.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (store.withdrawalInputModel?.currency != null) {
        if (!store.withdrawalInputModel!.currency!.isSingleNetwork) {
          showNetworkBottomSheet(
            context,
            store.network,
            store.withdrawalInputModel!.currency!.depositBlockchains,
            store.withdrawalInputModel!.currency!.iconUrl,
            store.updateNetwork,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = WithdrawalStore.of(context);

    final asset = store.withdrawalType == WithdrawalType.Asset
        ? store.withdrawalInputModel?.currency?.symbol
        : 'Matic';

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: store.header,
          onBackButtonTap: () {
            sRouter.pop();
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
                      if (store.withdrawalType == WithdrawalType.Asset &&
                          store.withdrawalInputModel!.currency!
                                  .withdrawalBlockchains.length >
                              1) {
                        showNetworkBottomSheet(
                          context,
                          store.network,
                          store.withdrawalInputModel!.currency!
                              .withdrawalBlockchains,
                          store.withdrawalInputModel!.currency!.iconUrl,
                          store.updateNetwork,
                          backOnClose: false,
                        );
                      }
                    },
                    child: SPaddingH24(
                      child: SStandardField(
                        controller: store.networkController,
                        labelText:
                            (store.withdrawalType == WithdrawalType.Asset &&
                                    store.withdrawalInputModel!.currency!
                                            .withdrawalBlockchains.length >
                                        1)
                                ? intl.currencyWithdraw_chooseNetwork
                                : intl.cryptoDeposit_network,
                        enabled: false,
                        hideIconsIfNotEmpty: false,
                        hideClearButton: true,
                        suffixIcons: [
                          if (store.withdrawalType == WithdrawalType.Asset &&
                              store.withdrawalInputModel!.currency!
                                      .withdrawalBlockchains.length >
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
                        maxLines: 3,
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
                            FocusScope.of(context).unfocus();

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
