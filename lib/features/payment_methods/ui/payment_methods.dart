import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
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
      create: (context) => PaymentMethodsStore()..getAddressBook(),
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
          return state.userCards.isEmpty && state.addressBookContacts.isEmpty
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
                          PaymentCardItem(
                            name: '${card.cardLabel} •••• ${card.last4}',
                            network: card.network,
                            currency: card.cardAssetSymbol,
                            expirationDate:
                                'Exp. ${card.expMonth}/${card.expYear}',
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

                                    final tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

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
                          ),
                        ],
                        if (state.addressBookContacts.isNotEmpty &&
                            state.isShowAccounts) ...[
                          MarketSeparator(text: intl.iban_send_accounts),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: state.addressBookContacts.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SCardRow(
                                icon: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SAccountIcon(),
                                ),
                                rightIcon: Padding(
                                  padding: const EdgeInsets.only(top: 9.0),
                                  child: SIconButton(
                                    onTap: () {
                                      sRouter
                                          .push(
                                        IbanEditBankAccountRouter(
                                          contact:
                                              state.addressBookContacts[index],
                                        ),
                                      )
                                          .then((value) async {
                                        await state.getAddressBook();
                                      });
                                    },
                                    defaultIcon: const SEditIcon(),
                                    pressedIcon: const SEditIcon(
                                      color: Color(0xFFA8B0BA),
                                    ),
                                  ),
                                ),
                                name:
                                    state.addressBookContacts[index].name ?? '',
                                amount: '',
                                helper:
                                    state.addressBookContacts[index].iban ?? '',
                                description: '',
                                needSpacer: true,
                                onTap: () {
                                  getIt<AppRouter>()
                                      .push(
                                    IbanSendAmountRouter(
                                      contact: state.addressBookContacts[index],
                                    ),
                                  )
                                      .then((value) async {
                                    await state.getAddressBook();
                                  });
                                },
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
