import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/bank_card/add_bank_card.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/payment_method_cards_widget.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_add_cash_from_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
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
  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {
      sAnalytics.tapOnTheButtonCloseForClosingSheetOnPayWithPMSheet(
        destinationWallet: currency?.symbol ?? '',
      );
    },
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.amount_screen_pay_with,
      needBottomPadding: false,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _PaymentMethodScreenBody(
        asset: currency,
        onSelected: onSelected,
        store: store,
        onSelectedCryptoAsset: onSelectedCryptoAsset,
      ),
    ],
  );
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({
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
    return SingleChildScrollView(
      child: Column(
        children: [
          if (store.isCardsAvailable) ...[
            const SpaceH24(),
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
          const SpaceH24(),
          STextDivider(intl.sell_amount_accounts),
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
    );
  }
}

void _onAddCardTap(BuildContext context, CurrencyModel? asset) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.white,
      pageBuilder: (BuildContext _, __, ___) {
        return AddBankCardScreen(
          onCardAdded: () {},
          amount: '',
          isPreview: true,
          asset: asset,
          divideDateAndLabel: true,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
