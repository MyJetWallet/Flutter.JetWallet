import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transfer_flow/store/transfer_confirmation_store.dart';
import 'package:jetwallet/features/transfer_flow/widgets/transfer_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
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

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing ? const WaitingScreen() : null,
      header: GlobalBasicAppBar(
        title: intl.buy_confirmation_title,
        subtitle: intl.amount_screen_tab_transfer,
        hasRightIcon: false,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  STransaction(
                    isLoading: !store.isDataLoaded,
                    fromAssetIconUrl: store.eurCurrency.iconUrl,
                    fromAssetDescription: store.fromLable,
                    fromAssetValue: store.fromAmount.toFormatCount(
                      symbol: store.eurCurrency.symbol,
                      accuracy: store.eurCurrency.accuracy,
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
                    toAssetValue: store.toAmount.toFormatCount(
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
                    child: SButton.blue(
                      text: intl.previewBuyWithAsset_confirm,
                      callback: !store.loader.loading
                          ? () {
                              store.confirmTransfer();
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
