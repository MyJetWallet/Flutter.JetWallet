import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/invest_transfer/store/invest_deposite_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'InvestDepositeConfrimationRoute')
class InvestDepositeConfrimationScreen extends StatelessWidget {
  const InvestDepositeConfrimationScreen({
    super.key,
    required this.amount,
    required this.assetId,
  });

  final Decimal amount;
  final String assetId;

  @override
  Widget build(BuildContext context) {
    return Provider<InvestDepositeConfirmationStore>(
      create: (context) => InvestDepositeConfirmationStore(
        amount: amount,
        assetId: assetId,
      ),
      builder: (context, child) => const _TransferConfirmationScreenBody(),
    );
  }
}

class _TransferConfirmationScreenBody extends StatelessObserverWidget {
  const _TransferConfirmationScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = InvestDepositeConfirmationStore.of(context);
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing ? const WaitingScreen() : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.amount_screen_tab_transfer,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
        onBackButtonTap: () {
          sRouter.maybePop();
        },
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WhatToWhatConvertWidget(
                  isLoading: false,
                  fromAssetIconUrl: store.currency.iconUrl,
                  fromAssetDescription: intl.invest_transfer_crypto_wallet,
                  fromAssetValue: store.amount.toFormatCount(
                    symbol: store.currency.symbol,
                    accuracy: store.currency.accuracy,
                  ),
                  fromAssetBaseAmount: '≈${store.baseCryptoAmount.toFormatCount(
                    symbol: store.eurCurrency.symbol,
                    accuracy: store.eurCurrency.accuracy,
                  )}',
                  toAssetIconUrl: store.currency.iconUrl,
                  toAssetDescription: intl.invest_transfer_invest,
                  toAssetValue: store.amount.toFormatCount(
                    symbol: store.currency.symbol,
                    accuracy: store.currency.accuracy,
                  ),
                  toAssetBaseAmount: '≈${store.baseCryptoAmount.toFormatCount(
                    symbol: store.eurCurrency.symbol,
                    accuracy: store.eurCurrency.accuracy,
                  )}',
                ),
                const SizedBox(height: 19),
                const SDivider(),
                SPolicyCheckbox(
                  height: 65,
                  firstText: intl.buy_confirmation_privacy_checkbox_1,
                  userAgreementText: intl.buy_confirmation_privacy_checkbox_2,
                  betweenText: ', ',
                  privacyPolicyText: intl.buy_confirmation_privacy_checkbox_3,
                  secondText: '',
                  activeText: '',
                  thirdText: '',
                  activeText2: '',
                  onCheckboxTap: () {
                    store.toggleCheckbox();
                  },
                  onUserAgreementTap: () {
                    launchURL(context, userAgreementLink);
                  },
                  onPrivacyPolicyTap: () {
                    launchURL(context, privacyPolicyLink);
                  },
                  onActiveTextTap: () {},
                  onActiveText2Tap: () {},
                  isChecked: store.isTermsAndConditionsChecked,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SPrimaryButton2(
                    active: store.isTermsAndConditionsChecked,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      store.confirm();
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
