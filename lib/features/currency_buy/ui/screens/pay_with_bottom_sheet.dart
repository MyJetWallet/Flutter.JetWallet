import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/bank_card/add_bank_card.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/balances_widget.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/payment_method_cards_widget.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:provider/provider.dart';
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
  final cards = sSignalRModules.cards.cardInfos
      .where(
        (element) => element.integration == IntegrationType.unlimintAlt,
      )
      .toList();

  final acounts = sSignalRModules.bankingProfileData?.banking?.accounts
          ?.where((element) => (element.balance ?? Decimal.zero) != Decimal.zero)
          .toList() ??
      <SimpleBankingAccount>[];

  if (cards.isNotEmpty || acounts.isNotEmpty) {
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
        BuyPaymentMethodScreen(
          asset: currency,
          onSelected: onSelected,
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

class BuyPaymentMethodScreen extends StatelessWidget {
  const BuyPaymentMethodScreen({
    super.key,
    required this.asset,
    this.onSelected,
  });

  final CurrencyModel asset;
  final void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected;

  @override
  Widget build(BuildContext context) {
    return Provider<PaymentMethodStore>(
      create: (context) => PaymentMethodStore()..init(asset),
      builder: (context, child) => _PaymentMethodScreenBody(
        asset: asset,
        onSelected: onSelected,
      ),
    );
  }
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({
    required this.asset,
    this.onSelected,
  });

  final CurrencyModel asset;
  final void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected;

  @override
  Widget build(BuildContext context) {
    final store = PaymentMethodStore.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceH24(),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: PaymentMethodCardsWidget(
              title: intl.payment_method_cards,
              asset: asset,
              onSelected: onSelected,
            ),
          ),
          const SpaceH24(),
          if (store.accounts.isNotEmpty)
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
