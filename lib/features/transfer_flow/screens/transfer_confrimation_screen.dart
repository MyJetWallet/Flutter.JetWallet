import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/transfer_flow/store/transfer_confirmation_store.dart';
import 'package:jetwallet/features/transfer_flow/widgets/transfer_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';

@RoutePage(name: 'TransferConfirmationRoute')
class TransferConfirmationScreen extends StatelessWidget {
  const TransferConfirmationScreen({
    super.key,
    this.fromCard,
    this.toCard,
    this.fromAccount,
    this.toAccount,
    required this.amount,
  });

  final CardDataModel? fromCard;
  final CardDataModel? toCard;
  final SimpleBankingAccount? fromAccount;
  final SimpleBankingAccount? toAccount;

  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    return Provider<TransferConfirmationStore>(
      create: (context) => TransferConfirmationStore()
        ..init(
          amount: amount,
          fromCard: fromCard,
          toCard: toCard,
          fromAccount: fromAccount,
          toAccount: toAccount,
        ),
      builder: (context, child) => const _TransferConfirmationScreenBody(),
    );
  }
}

class _TransferConfirmationScreenBody extends StatelessObserverWidget {
  const _TransferConfirmationScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = TransferConfirmationStore.of(context);
    final colors = sKit.colors;

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: true,
              buttonName: intl.previewBuyWithUmlimint_close,
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.amount_screen_tab_transfer,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
        onBackButtonTap: () {
          sAnalytics.tapOnTheBackFromTransferOrderSummaryButton(
            transferFrom: store.fromType.analyticsValue,
            transferTo: store.toType.analyticsValue,
            enteredAmount: store.fromAmount.toString(),
          );
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
                  isLoading: !store.isDataLoaded,
                  fromAssetIconUrl: store.eurCurrency.iconUrl,
                  fromAssetDescription: store.fromLable,
                  fromAssetValue: volumeFormat(
                    symbol: store.eurCurrency.symbol,
                    accuracy: store.eurCurrency.accuracy,
                    decimal: store.fromAmount,
                  ),
                  fromAssetCustomIcon: store.fromType == CredentialsType.unlimitCard
                      ? Assets.svg.assets.fiat.cardAlt.simpleSvg(
                          width: 40,
                        )
                      : Assets.svg.other.medium.bankAccount.simpleSvg(
                          width: 40,
                        ),
                  toAssetIconUrl: store.eurCurrency.iconUrl,
                  toAssetDescription: store.toLable,
                  toAssetValue: volumeFormat(
                    decimal: store.toAmount,
                    accuracy: store.eurCurrency.accuracy,
                    symbol: store.eurCurrency.symbol,
                  ),
                ),
                TransferConfirmationInfoGrid(
                  isDataLoaded: store.isDataLoaded,
                  isToCard: store.toType == CredentialsType.unlimitCard,
                  sendToLable: store.toLable,
                  benificiary: store.benificiary,
                  reference: store.reference,
                  paymentFee: store.paymentFee,
                  processingFee: store.processingFee,
                ),
                const SizedBox(height: 16),
                Text(
                  intl.transfer_confirmation_time_to_transaction,
                  style: sCaptionTextStyle.copyWith(
                    color: SColorsLight().gray8,
                  ),
                ),
                const SizedBox(height: 16),
                const SDivider(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SPrimaryButton2(
                    active: !store.loader.loading,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      store.confirmTransfer();
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
