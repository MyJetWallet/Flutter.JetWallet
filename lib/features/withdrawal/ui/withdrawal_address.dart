import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/currency_withdraw/model/address_validation_union.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/widgets/network_bottom_sheet/show_witrhdrawal_network_bottom_sheet.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'WithdrawalAddressRouter')
class WithdrawalAddressScreen extends StatefulObserverWidget {
  const WithdrawalAddressScreen({super.key});

  @override
  State<WithdrawalAddressScreen> createState() => _WithdrawalAddressScreenState();
}

class _WithdrawalAddressScreenState extends State<WithdrawalAddressScreen> {
  final scrollController = ScrollController();

  bool loading = false;

  @override
  void initState() {
    final store = WithdrawalStore.of(context);

    if (store.withdrawalType == WithdrawalType.jar) {
      sAnalytics.jarScreenViewWithdrawJar(
        asset: store.withdrawalInputModel!.jar!.assetSymbol,
        network: 'TRC20',
        target: store.withdrawalInputModel!.jar!.target.toInt(),
        balance: store.withdrawalInputModel!.jar!.balanceInJarAsset,
        isOpen: store.withdrawalInputModel!.jar!.status == JarStatus.active,
      );
    } else {
      sAnalytics.cryptoSendSendAssetNameScreenView(
        asset: store.withdrawalInputModel?.currency?.symbol ?? '',
        sendMethodType: '0',
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (store.withdrawalInputModel?.currency != null && store.withdrawalType != WithdrawalType.jar) {
        if (!store.withdrawalInputModel!.currency!.isSingleNetworkForBlockchainSend) {
          await store.getFeeInfo();
          showWithdrawalNetworkBottomSheet(
            context,
            store.network,
            store.networks,
            store.withdrawalInputModel!.currency!.iconUrl,
            store.withdrawalInputModel!.currency!.symbol,
            store.updateNetwork,
          );
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = WithdrawalStore.of(context);

    String? asset;
    if (store.withdrawalType == WithdrawalType.asset) {
      asset = store.withdrawalInputModel?.currency?.symbol;
    } else if (store.withdrawalType == WithdrawalType.jar) {
      asset = store.withdrawalInputModel?.jar?.assetSymbol;
    } else {
      asset = 'Matic';
    }

    return PopScope(
      canPop: !store.loader.loading,
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        color: colors.grey5,
        loading: store.loader,
        header: SPaddingH24(
          child: SSmallHeader(
            title: store.header,
            onBackButtonTap: () {
              sRouter.maybePop();
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
                        if (store.withdrawalType == WithdrawalType.asset && store.networks.length > 1) {
                          showWithdrawalNetworkBottomSheet(
                            context,
                            store.network,
                            store.networks,
                            store.withdrawalInputModel!.currency!.iconUrl,
                            store.withdrawalInputModel!.currency!.symbol,
                            store.updateNetwork,
                            backOnClose: false,
                          );
                        }
                      },
                      child: SPaddingH24(
                        child: SStandardField(
                          controller: store.networkController,
                          labelText: (store.withdrawalType == WithdrawalType.asset && store.networks.length > 1)
                              ? intl.currencyWithdraw_chooseNetwork
                              : intl.cryptoDeposit_network,
                          enabled: false,
                          hideIconsIfNotEmpty: false,
                          hideClearButton: true,
                          suffixIcons: [
                            if (store.withdrawalType == WithdrawalType.asset && store.networks.length > 1)
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
                        maxLines: 1,
                        onErase: () => store.eraseAddress(),
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              if (store.withdrawalType != WithdrawalType.jar) {
                                sAnalytics.cryptoSendTapPaste(
                                  asset: store.withdrawalInputModel!.currency!.symbol,
                                  sendMethodType: '0',
                                );
                              }

                              store.pasteAddress(scrollController);
                            },
                            defaultIcon: const SPasteIcon(),
                          ),
                          SIconButton(
                            onTap: () {
                              if (store.withdrawalType != WithdrawalType.jar) {
                                sAnalytics.cryptoSendTapQr(
                                  asset: store.withdrawalInputModel!.currency!.symbol,
                                  sendMethodType: '0',
                                );
                              }

                              store.scanAddressQr(
                                context,
                                scrollController,
                              );
                            },
                            defaultIcon: const SQrCodeIcon(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (store.network.tagType == TagType.tag || store.network.tagType == TagType.memo) ...[
                    const SDivider(),
                    Material(
                      color: colors.white,
                      child: SPaddingH24(
                        child: SStandardField(
                          isError: store.tagError,
                          labelText: store.withdrawalInputModel!.currency!.symbol == 'XRP'
                              ? intl.currencyWithdraw_enterTagOrMemo
                              : intl.currencyWithdraw_enterTag,
                          focusNode: store.tagFocus,
                          controller: store.tagController,
                          onChanged: (value) => store.updateTag(value),
                          onErase: () => store.eraseTag(),
                          maxLines: 3,
                          suffixIcons: [
                            SIconButton(
                              onTap: () {
                                if (store.withdrawalType != WithdrawalType.jar) {
                                  sAnalytics.cryptoSendTapPaste(
                                    asset: store.withdrawalInputModel!.currency!.symbol,
                                    sendMethodType: '0',
                                  );
                                }

                                store.pasteTag(scrollController);
                              },
                              defaultIcon: const SPasteIcon(),
                            ),
                            SIconButton(
                              onTap: () {
                                sAnalytics.cryptoSendTapQr(
                                  asset: store.withdrawalInputModel!.currency!.symbol,
                                  sendMethodType: '0',
                                );

                                store.scanTagQr(
                                  context,
                                  scrollController,
                                );
                              },
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
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SButton.blue(
                          isLoading: loading,
                          text: intl.currencyWithdraw_continue,
                          callback: store.isReadyToContinue
                              ? () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (store.withdrawalType == WithdrawalType.jar) {
                                    sAnalytics.jarTapOnButtonContinueJarWithdrawOnWithdraw(
                                      asset: store.withdrawalInputModel!.jar!.assetSymbol,
                                      network: 'TRC20',
                                      target: store.withdrawalInputModel!.jar!.target.toInt(),
                                      balance: store.withdrawalInputModel!.jar!.balanceInJarAsset,
                                      isOpen: store.withdrawalInputModel!.jar!.status == JarStatus.active,
                                    );
                                  } else {
                                    sAnalytics.cryptoSendTapContinue(
                                      asset: store.withdrawalInputModel!.currency!.symbol,
                                      sendMethodType: '0',
                                    );
                                  }

                                  FocusScope.of(context).unfocus();

                                  await store.validateOnContinue(context);

                                  setState(() {
                                    loading = false;
                                  });
                                }
                              : null,
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
      ),
    );
  }
}
