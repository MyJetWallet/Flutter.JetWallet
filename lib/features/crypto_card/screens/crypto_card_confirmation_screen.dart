import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardConfirmationRoute')
class CryptoCardConfirmationScreen extends StatelessWidget {
  const CryptoCardConfirmationScreen({super.key, required this.fromAssetSymbol});

  final String fromAssetSymbol;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoCardConfirmationStore(fromAssetSymbol: fromAssetSymbol)..loadPrewiev(),
      child: const _ConfirmationBody(),
    );
  }
}

class _ConfirmationBody extends StatelessWidget {
  const _ConfirmationBody();

  @override
  Widget build(BuildContext context) {
    final store = CryptoCardConfirmationStore.of(context);
    return Observer(
      builder: (context) {
        return SPageFrame(
          loaderText: intl.loader_please_wait,
          loading: store.loader,
          customLoader: store.isPreviewLoaded
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
                        isLoading: !store.isPreviewLoaded,
                        fromAssetIconUrl: store.fromAsset.iconUrl,
                        fromAssetDescription: store.fromAsset.description,
                        fromAssetValue: store.fromAmount.toFormatCount(
                          symbol: store.fromAssetSymbol,
                          accuracy: store.fromAsset.accuracy,
                        ),
                        fromAssetBaseAmount: store.toAmount.toFormatSum(
                          symbol: store.toAssetSymbol,
                          accuracy: store.toAsset.accuracy,
                        ),
                        hasSecondAsset: false,
                      ),
                    ),
                    const SDivider(
                      withHorizontalPadding: true,
                    ),
                    const SpaceH8(),
                    TwoColumnCell(
                      label: 'Pay with',
                      value: store.fromAsset.description,
                      leftValueIcon: NetworkIconWidget(
                        store.fromAsset.iconUrl,
                      ),
                      type: store.isPreviewLoaded ? TwoColumnCellType.def : TwoColumnCellType.loading,
                    ),
                    TwoColumnCell(
                      label: 'Card issue cost',
                      value: '#####',
                      type: store.isPreviewLoaded ? TwoColumnCellType.def : TwoColumnCellType.loading,
                    ),
                    TwoColumnCell(
                      label: '#####% discount',
                      value: '#####',
                      type: store.isPreviewLoaded ? TwoColumnCellType.def : TwoColumnCellType.loading,
                    ),
                    TwoColumnCell(
                      label: 'Price',
                      value: '##### = #####',
                      type: store.isPreviewLoaded ? TwoColumnCellType.def : TwoColumnCellType.loading,
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
                        onCheckboxTap: store.toggleCheckBox,
                        onUserAgreementTap: () {
                          launchURL(context, userAgreementLink);
                        },
                        onPrivacyPolicyTap: () {
                          launchURL(context, privacyPolicyLink);
                        },
                        onActiveTextTap: () {},
                        onActiveText2Tap: () {},
                        isChecked: store.isCheckBoxSelected,
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
                          callback: store.isContinueAvaible
                              ? () {
                                  store.onContinueTap();
                                }
                              : null,
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
}
