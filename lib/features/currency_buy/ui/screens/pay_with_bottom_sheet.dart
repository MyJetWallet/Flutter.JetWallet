import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/payment_method_cards_widget.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_add_cash_from_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

void showPayWithBottomSheet({
  required BuildContext context,
  CurrencyModel? currency,
  void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected,
  bool hideCards = false,
  void Function({
    CurrencyModel? newCurrency,
  })? onSelectedCryptoAsset,
}) {
  final store = PaymentMethodStore()
    ..init(
      asset: currency,
      hideCards: hideCards,
    );

  if (store.cards.isNotEmpty || store.accounts.isNotEmpty) {
    sAnalytics.payWithPMSheetView(
      destinationWallet: currency?.symbol ?? '',
      listOfAvailablePMs: [
        if (store.isCardsAvailable) ...[
          'New card',
          ...List.generate(
            store.cards.length,
            (index) => 'Saved card ${store.cards[index].last4}',
          ),
        ],
        if (store.isBankingAccountsAvaible)
          ...List.generate(
            store.accounts.length,
            (index) {
              return index == 0
                  ? 'CJ ${store.accounts[index].last4IbanCharacters}'
                  : 'Unlimint ${store.accounts[index].last4IbanCharacters}';
            },
          ),
      ],
    );

    _showPayWithBottomSheet(
      context: context,
      currency: currency,
      onSelected: onSelected,
      onSelectedCryptoAsset: onSelectedCryptoAsset,
      store: store,
    );
  } else {
    final kycState = getIt.get<KycService>();
    final kycHandler = getIt.get<KycAlertHandler>();

    final isCardsAvailable = sSignalRModules.buyMethods.any((element) => element.id == PaymentMethodType.bankCard);

    final status = kycOperationStatus(KycStatus.allowed);
    if (!isCardsAvailable) {
      sNotification.showError(
        intl.operation_bloked_text,
        id: 1,
      );
    } else if (kycState.depositStatus == status) {
      _showPayWithBottomSheet(
        context: context,
        currency: currency,
        onSelected: onSelected,
        onSelectedCryptoAsset: onSelectedCryptoAsset,
        store: store,
      );
    } else {
      kycHandler.handle(
        status: kycState.depositStatus,
        isProgress: kycState.verificationInProgress,
        currentNavigate: () => _showPayWithBottomSheet(
          context: context,
          currency: currency,
          onSelected: onSelected,
          onSelectedCryptoAsset: onSelectedCryptoAsset,
          store: store,
        ),
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
      );
    }
  }
}

void _showPayWithBottomSheet({
  required BuildContext context,
  CurrencyModel? currency,
  void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected,
  void Function({
    CurrencyModel? newCurrency,
  })? onSelectedCryptoAsset,
  required PaymentMethodStore store,
}) {
  sRouter
      .push(
        PayWithScreenRouter(
          asset: currency,
          onSelected: onSelected,
          store: store,
          onSelectedCryptoAsset: onSelectedCryptoAsset,
        ),
      )
      .then(
        (value) => sAnalytics.tapOnTheButtonCloseForClosingSheetOnPayWithPMSheet(
          destinationWallet: currency?.symbol ?? '',
        ),
      );
}

@RoutePage(name: 'PayWithScreenRouter')
class PayWithScreen extends StatelessObserverWidget {
  const PayWithScreen({
    required this.asset,
    required this.store,
    this.onSelected,
    this.onSelectedCryptoAsset,
  });

  final CurrencyModel? asset;
  final void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected;
  final PaymentMethodStore store;
  final void Function({
    CurrencyModel? newCurrency,
  })? onSelectedCryptoAsset;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.amount_screen_pay_with,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (store.isCardsAvailable) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: PaymentMethodCardsWidget(
                  title: intl.buy_external_cards,
                  asset: asset,
                  onSelected: onSelected,
                  cards: store.cards,
                ),
              ),
            ],
            const SpaceH16(),
            if (store.isP2PAvaible) ...[
              STextDivider(intl.buy_local_methods),
              SimpleTableAsset(
                label: intl.buy_p2p_service,
                supplement: intl.buy_transfer,
                assetIcon: Assets.svg.assets.fiat.p2p.simpleSvg(
                  width: 24,
                ),
                hasRightValue: false,
                onTableAssetTap: () {
                  // TODO (yaroslav): change this late
                  if (!(sSignalRModules.pendingOperationCount > 1)) {
                    showUnfinishedOperationPopUp(context);
                  } else {
                    sRouter.push(PaymentCurrenceBuyRouter(currency: asset!));
                  }
                },
              ),
            ],
            STextDivider(intl.buy_wallets_accounts),
            SimpleTableAsset(
              label: intl.market_crypto,
              supplement: intl.internal_exchange,
              assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
                width: 24,
              ),
              rightValue: !getIt<AppStore>().isBalanceHide
                  ? calculateCryptoBalance()
                  : '**** ${sSignalRModules.baseCurrency.symbol}',
              onTableAssetTap: () {
                showAddCashFromBottomSheet(
                  context: context,
                  onClose: () {},
                  skipAsset: asset?.symbol,
                  onChooseAsset: (currency) {
                    if (onSelectedCryptoAsset != null) {
                      onSelectedCryptoAsset?.call(newCurrency: currency);
                    } else {
                      sRouter.push(
                        AmountRoute(
                          tab: AmountScreenTab.convert,
                          asset: currency,
                          toAsset: asset,
                        ),
                      );
                    }
                  },
                );
              },
            ),
            if (store.accounts.isNotEmpty) ...[
              for (final account in store.accounts)
                SimpleTableAsset(
                  assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                    width: 24,
                  ),
                  label: account.label ?? 'Account 1',
                  supplement: intl.internal_exchange,
                  onTableAssetTap: () {
                    sAnalytics.tapOnTheButtonSomePMForBuyOnPayWithPMSheet(
                      destinationWallet: asset?.symbol ?? '',
                      pmType: account.isClearjuctionAccount
                          ? PaymenthMethodType.cjAccount
                          : PaymenthMethodType.unlimitAccount,
                      buyPM: account.isClearjuctionAccount
                          ? 'CJ  ${account.last4IbanCharacters}'
                          : 'Unlimint  ${account.last4IbanCharacters}',
                    );

                    if (onSelected != null) {
                      onSelected!(account: account);
                    } else {
                      sRouter.push(
                        AmountRoute(
                          tab: AmountScreenTab.buy,
                          asset: asset,
                          account: account,
                        ),
                      );
                    }
                  },
                  rightValue: getIt<AppStore>().isBalanceHide
                      ? '**** ${account.currency}'
                      : '${account.balance} ${account.currency}',
                ),
            ],
            const SpaceH45(),
          ],
        ),
      ),
    );
  }
}

Future<void> showUnfinishedOperationPopUp(BuildContext context) async {
  await sShowAlertPopup(
    context,
    primaryText: intl.p2p_buy_unfinished_operation,
    secondaryText: intl.p2p_buy_you_have_unfinished,
    primaryButtonName: intl.prepaid_card_continue,
    secondaryButtonName: intl.profileDetails_cancel,
    textAlign: TextAlign.left,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () async {
      await sRouter.push(
        TransactionHistoryRouter(
          initialIndex: 1,
        ),
      );
    },
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
