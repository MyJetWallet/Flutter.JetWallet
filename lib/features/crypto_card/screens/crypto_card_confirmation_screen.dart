import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardConfirmationRoute')
class CryptoCardConfirmationScreen extends StatelessWidget {
  const CryptoCardConfirmationScreen({super.key, required this.fromAssetSymbol});

  final String fromAssetSymbol;

  @override
  Widget build(BuildContext context) {
    final asset = getIt<FormatService>().findCurrency(
      assetSymbol: fromAssetSymbol,
    );
    return SPageFrame(
      loaderText: intl.loader_please_wait,
      //loading: store.loader,
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
                      callback: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
