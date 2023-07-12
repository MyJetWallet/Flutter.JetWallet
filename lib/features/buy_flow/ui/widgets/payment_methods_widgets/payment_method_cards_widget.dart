import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/bank_card/add_bank_card.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/add_bank_card.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class PaymentMethodCardsWidget extends StatelessObserverWidget {
  const PaymentMethodCardsWidget({
    super.key,
    required this.title,
    required this.asset,
    required this.currency,
  });

  final String title;
  final CurrencyModel asset;
  final PaymentAsset currency;

  void onAddCardTap(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final status = kycOperationStatus(KycStatus.kycRequired);
    final isUserVerified = kycState.depositStatus != status &&
        kycState.sellStatus != status &&
        kycState.withdrawalStatus != status;

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
            currency: PaymentMethodStore.of(context).selectedAssset,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = PaymentMethodStore.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        MarketSeparator(text: title),
        const SizedBox(height: 16),
        SPaddingH24(
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1 / .59,
            ),
            itemCount: store.unlimintAltCards.length + 1,
            itemBuilder: (context, i) {
              if (i == store.unlimintAltCards.length) {
                return PaymentMethodCard.cardIcon(
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: SPlusIcon(
                      color: sKit.colors.blue,
                    ),
                  ),
                  name: 'Add card',
                  onTap: () {
                    final kycState = getIt.get<KycService>();
                    final kycHandler = getIt.get<KycAlertHandler>();

                    final status = kycOperationStatus(KycStatus.allowed);
                    if (kycState.depositStatus == status) {
                      onAddCardTap(context);
                    } else {
                      kycHandler.handle(
                        status: kycState.depositStatus,
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => onAddCardTap(context),
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    }
                    ;
                  },
                );
              } else {
                final formatted = formattedCircleCard(
                  store.unlimintAltCards[i],
                  sSignalRModules.baseCurrency,
                );

                return PaymentMethodCard.bankCard(
                  network: store.unlimintAltCards[i].network,
                  name: store.unlimintAltCards[i].cardLabel ?? '',
                  subName: formatted.last4Digits,
                  onTap: () {
                    sRouter.push(
                      BuyAmountRoute(
                        asset: asset,
                        currency: currency,
                        card: store.unlimintAltCards[i],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
