import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/invest_transfer/store/invest_withdraw_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing ? const WaitingScreen() : null,
      header: GlobalBasicAppBar(
        title: intl.buy_confirmation_title,
        subtitle: intl.amount_screen_tab_transfer,
        hasRightIcon: false,
        onLeftIconTap: () {
          sRouter.maybePop();
        },
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
                    isLoading: false,
                    fromAssetIconUrl: store.currency.iconUrl,
                    fromAssetDescription: intl.invest_transfer_invest,
                    fromAssetValue: store.amount.toFormatCount(
                      symbol: store.currency.symbol,
                      accuracy: store.currency.accuracy,
                    ),
                    fromAssetBaseAmount: '≈${store.baseCryptoAmount.toFormatCount(
                      symbol: store.eurCurrency.symbol,
                      accuracy: store.eurCurrency.accuracy,
                    )}',
                    toAssetIconUrl: store.currency.iconUrl,
                    toAssetDescription: intl.invest_transfer_crypto_wallet,
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
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: SButton.blue(
                      text: intl.previewBuyWithAsset_confirm,
                      callback: store.isTermsAndConditionsChecked
                          ? () {
                              store.confirm();
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
