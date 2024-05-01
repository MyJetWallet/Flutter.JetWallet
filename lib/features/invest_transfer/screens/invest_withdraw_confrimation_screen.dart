import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest_transfer/store/invest_withdraw_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'InvestWithdrawConfrimationRoute')
class InvestWithdrawConfrimationScreen extends StatelessWidget {
  const InvestWithdrawConfrimationScreen({
    super.key,
    required this.amount,
    required this.assetId,
  });

  final Decimal amount;
  final String assetId;

  @override
  Widget build(BuildContext context) {
    return Provider<InvestWithdrawConfirmationStore>(
      create: (context) => InvestWithdrawConfirmationStore(
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
    final store = InvestWithdrawConfirmationStore.of(context);
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: true,
              primaryText: intl.buy_confirmation_local_p2p_processing_title,
              onSkip: () {
                navigateToRouter();
              },
            )
          : null,
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
                  fromAssetDescription: intl.invest_transfer_invest,
                  fromAssetValue: volumeFormat(
                    symbol: store.currency.symbol,
                    accuracy: store.currency.accuracy,
                    decimal: store.amount,
                  ),
                  fromAssetBaseAmount: '≈${volumeFormat(
                    symbol: store.eurCurrency.symbol,
                    accuracy: store.eurCurrency.accuracy,
                    decimal: store.baseCryptoAmount,
                  )}',
                  toAssetIconUrl: store.currency.iconUrl,
                  toAssetDescription: intl.invest_transfer_crypto_wallet,
                  toAssetValue: volumeFormat(
                    decimal: store.amount,
                    symbol: store.currency.symbol,
                    accuracy: store.currency.accuracy,
                  ),
                  toAssetBaseAmount: '≈${volumeFormat(
                    symbol: store.eurCurrency.symbol,
                    accuracy: store.eurCurrency.accuracy,
                    decimal: store.baseCryptoAmount,
                  )}',
                ),
                const SizedBox(height: 19),
                const SDivider(),
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
