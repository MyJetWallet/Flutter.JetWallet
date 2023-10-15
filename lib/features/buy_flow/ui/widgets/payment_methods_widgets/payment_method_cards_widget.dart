import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/bank_card/add_bank_card.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/helpers/is_card_expired.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

class PaymentMethodCardsWidget extends StatelessObserverWidget {
  const PaymentMethodCardsWidget({
    super.key,
    required this.title,
    required this.asset,
    this.onSelected,
  });

  final String title;
  final CurrencyModel asset;
  final void Function({
    CircleCard? inputCard,
    SimpleBankingAccount? account,
  })? onSelected;

  void onAddCardTap(BuildContext context) {
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
            method: const BuyMethodDto(
              id: PaymentMethodType.bankCard,
              termsAccepted: true,
              category: PaymentMethodCategory.cards,
            ),
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

  @override
  Widget build(BuildContext context) {
    final store = PaymentMethodStore.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        MarketSeparator(
          text: title,
          isNeedDivider: false,
        ),
        const SpaceH16(),
        ResponsiveGridList(
          horizontalGridSpacing: 12,
          verticalGridSpacing: 12,
          horizontalGridMargin: 24,
          minItemsPerRow: 2,
          maxItemsPerRow: 2,
          minItemWidth: 157,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
          ),
          children: store.unlimintAltCards.map(
            (e) {
              final formatted = formattedCircleCard(
                e,
                sSignalRModules.baseCurrency,
              );

              return PaymentMethodCard.bankCard(
                network: e.network,
                name: e.cardLabel ?? '',
                subName: formatted.last4Digits,
                subName2: 'Exp. ${e.expMonth}/${e.expYear}',
                expire: isCardExpired(
                  e.expMonth,
                  e.expYear,
                ),
                onTap: () {
                  if (!isCardExpired(
                    e.expMonth,
                    e.expYear,
                  )) {
                    if (onSelected != null) {
                      onSelected!(inputCard: e);
                    } else {
                      sRouter.push(
                        BuyAmountRoute(
                          asset: asset,
                          card: e,
                        ),
                      );
                    }
                  }
                },
              );
            },
          ).toList()
            ..add(
              PaymentMethodCard.cardIcon(
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SPlusIcon(
                    color: sKit.colors.blue,
                  ),
                ),
                name: intl.add_card_text,
                onTap: () {
                  sAnalytics.newBuyTapAddCard();

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
                },
              ),
            ),
        ),
      ],
    );
  }
}
