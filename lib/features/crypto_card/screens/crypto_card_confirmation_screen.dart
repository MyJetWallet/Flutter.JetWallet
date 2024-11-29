import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';

@RoutePage(name: 'CryptoCardConfirmationRoute')
class CryptoCardConfirmationScreen extends StatefulWidget {
  const CryptoCardConfirmationScreen({super.key, required this.fromAssetSymbol});

  final String fromAssetSymbol;

  @override
  State<CryptoCardConfirmationScreen> createState() => _CryptoCardConfirmationScreenState();
}

class _CryptoCardConfirmationScreenState extends State<CryptoCardConfirmationScreen> {
  StackLoaderStore loader = StackLoaderStore();

  bool isCreating = false;

  @override
  Widget build(BuildContext context) {
    final asset = getIt<FormatService>().findCurrency(
      assetSymbol: widget.fromAssetSymbol,
    );
    loader = StackLoaderStore();
    return Observer(
      builder: (context) {
        return SPageFrame(
          loaderText: intl.loader_please_wait,
          loading: loader,
          customLoader: isCreating
              ? WaitingScreen(
                  secondaryText: '',
                  onSkip: () {},
                  isCanClouse: false,
                )
              : null,
          header: const GlobalBasicAppBar(
            hasRightIcon: false,
            title: 'Order summary',
            subtitle: 'Card issue',
          ),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SPaddingH24(
                      child: STransaction(
                        isLoading: false,
                        fromAssetIconUrl: asset.iconUrl,
                        fromAssetDescription: asset.description,
                        fromAssetValue: '4.12 USDT',
                        fromAssetBaseAmount: '4 EUR',
                        hasSecondAsset: false,
                      ),
                    ),
                    const SDivider(
                      withHorizontalPadding: true,
                    ),
                    const SpaceH8(),
                    TwoColumnCell(
                      label: 'Pay with',
                      value: asset.description,
                      leftValueIcon: NetworkIconWidget(
                        asset.iconUrl,
                      ),
                    ),
                    const TwoColumnCell(
                      label: 'Card issue cost',
                      value: '8 EUR',
                    ),
                    const TwoColumnCell(
                      label: '50% discount',
                      value: '-4 EUR',
                    ),
                    const TwoColumnCell(
                      label: 'Price',
                      value: '1 USDT = 0.95 EUR',
                    ),
                    const SpaceH16(),
                    const SDivider(
                      withHorizontalPadding: true,
                    ),
                    SPaddingH24(
                      child: SPolicyCheckbox(
                        height: 65,
                        firstText: intl.buy_confirmation_privacy_checkbox_1,
                        userAgreementText: intl.buy_confirmation_privacy_checkbox_2,
                        betweenText: ', ',
                        privacyPolicyText: intl.buy_confirmation_privacy_checkbox_3,
                        secondText: '',
                        activeText: '',
                        thirdText: '',
                        activeText2: '',
                        onCheckboxTap: () {},
                        onUserAgreementTap: () {
                          launchURL(context, userAgreementLink);
                        },
                        onPrivacyPolicyTap: () {
                          launchURL(context, privacyPolicyLink);
                        },
                        onActiveTextTap: () {},
                        onActiveText2Tap: () {},
                        isChecked: true,
                      ),
                    ),
                    const SpaceH24(),
                    const Spacer(),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 16,
                          bottom: 16 + MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
                        ),
                        child: SButton.black(
                          text: intl.crypto_card_pay_continue,
                          callback: () {
                            createCryptoCard();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createCryptoCard() async {
    try {
      isCreating = true;
      loader.startLoadingImmediately();
      // const model = CreateCryptoCardRequestModel(
      //   label: 'lable',
      // );

      // final response = await sNetwork.getWalletModule().createCryptoCard(model);

      // TODO (Yaroslav): remove this code
      sSignalRModules.cryptoCardProfile = const CryptoCardProfile(
        associateAssetList: ['USDT'],
        cards: [
          CryptoCardModel(
            cardId: 'mock',
            label: 'lable',
            last4: '5555',
            status: CryptoCardStatus.inCreation,
          ),
        ],
      );

      unawaited(
        Future.delayed(
          const Duration(seconds: 3),
          () {
            sSignalRModules.cryptoCardProfile = const CryptoCardProfile(
              associateAssetList: ['USDT'],
              cards: [
                CryptoCardModel(
                  cardId: 'mock',
                  label: 'lable',
                  last4: '5555',
                  status: CryptoCardStatus.active,
                ),
              ],
            );
          },
        ),
      );

      await sRouter
          .push(
        SuccessScreenRouter(
          secondaryText: 'You have successfully paid for the card.',
          onCloseButton: () {},
        ),
      )
          .then(
        (value) {
          sRouter.popUntilRoot();
          sRouter.push(const CryptoCardNameRoute());
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {}
  }
}
