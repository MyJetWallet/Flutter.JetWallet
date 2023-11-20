import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/bank_card/edit_bank_card.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/payment_methods/store/payment_methods_store.dart';
import 'package:jetwallet/features/payment_methods/ui/widgets/payment_card_item.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/is_card_expired.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'PaymentMethodsRouter')
class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<PaymentMethodsStore>(
      create: (context) => PaymentMethodsStore(),
      builder: (context, child) => const _PaymentMethodsBody(),
    );
  }
}

class _PaymentMethodsBody extends StatelessObserverWidget {
  const _PaymentMethodsBody();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final loader = StackLoaderStore();

    final state = PaymentMethodsStore.of(context);

    return SPageFrame(
      loaderText: intl.paymentMethods_pleaseWait,
      loading: loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.paymentMethods_paymentMethods,
        ),
      ),
      child: state.union.maybeWhen(
        success: () {
          return state.userCards.isEmpty
              ? ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 170),
                    Center(
                      child: Image.asset(
                        noSavedCards,
                        height: 80,
                      ),
                    ),
                    const SpaceH32(),
                    Text(
                      intl.paymentMethods_noSavedCards,
                      textAlign: TextAlign.center,
                      style: sTextH3Style,
                    ),
                    SPaddingH24(
                      child: Text(
                        intl.paymentMethod_text,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                    ),
                    const SpaceH94(),
                  ],
                )
              : Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      children: [
                        MarketSeparator(text: intl.payment_method_cards),
                        for (final card in state.userCards) ...[
                          Builder(
                            builder: (context) {
                              var cLabel = card.cardLabel ?? '';

                              var chSize = MediaQuery.of(context).devicePixelRatio == 3.0 ? 11 : 8;

                              if (cLabel.length > chSize) {
                                cLabel = cLabel.substring(0, chSize) + '...';
                              }

                              return PaymentCardItem(
                                name: '$cLabel •••• ${card.last4}',
                                network: card.network,
                                currency: 'EUR',
                                expirationDate: 'Exp. ${card.expMonth}/${card.expYear}',
                                expired: isCardExpired(card.expMonth, card.expYear),
                                status: card.status,
                                showDelete: false,
                                onDelete: () {},
                                showEdit: true,
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      barrierColor: Colors.white,
                                      pageBuilder: (BuildContext _, __, ___) {
                                        return EditBankCardScreen(
                                          card: card,
                                        );
                                      },
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
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
                                  ).then((value) async {
                                    await state.clearData();
                                  });
                                },
                                removeDivider: state.userCards.last == card,
                                onTap: () {},
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ],
                );
        },
        orElse: () {
          return const LoaderSpinner();
        },
      ),
    );
  }
}
