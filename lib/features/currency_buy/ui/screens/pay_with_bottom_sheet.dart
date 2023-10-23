import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/bank_card/add_bank_card.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/balances_widget.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/payment_method_cards_widget.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

void showPayWithBottomSheet({
  required BuildContext context,
  required CurrencyModel currency,
  void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected,
}) {
  final store = PaymentMethodStore()..init(currency);

  if (store.cards.isNotEmpty || store.accounts.isNotEmpty) {
    sShowBasicModalBottomSheet(
      context: context,
      then: (value) {},
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
        ),
      ],
    );
  } else {
    final kycState = getIt.get<KycService>();
    final kycHandler = getIt.get<KycAlertHandler>();

    final status = kycOperationStatus(KycStatus.allowed);
    if (kycState.depositStatus == status) {
      _onAddCardTap(context, currency);
    } else {
      kycHandler.handle(
        status: kycState.depositStatus,
        isProgress: kycState.verificationInProgress,
        currentNavigate: () => _onAddCardTap(context, currency),
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
      );
    }
  }
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({
    required this.asset,
    required this.store,
    this.onSelected,
  });

  final CurrencyModel asset;
  final void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected;
  final PaymentMethodStore store;

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
                title: intl.payment_method_cards,
                asset: asset,
                onSelected: onSelected,
                cards: store.cards,
              ),
            ),
          ],
          if (store.accounts.isNotEmpty) ...[
            const SpaceH24(),
            BalancesWidget(
              onTap: (account) {
                if (onSelected != null) {
                  onSelected!(account: account);
                } else {
                  sRouter.push(
                    BuyAmountRoute(
                      asset: asset,
                      account: account,
                    ),
                  );
                }
              },
              accounts: store.accounts,
            ),
          ],
          const SpaceH45(),
        ],
      ),
    );
  }
}

void _onAddCardTap(BuildContext context, CurrencyModel asset) {
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
