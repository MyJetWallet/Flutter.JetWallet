import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/di/di.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../../widgets/action_bottom_sheet_header.dart';
import '../../../actions/action_buy/widgets/action_buy_subheader.dart';
import '../../../kyc/helper/kyc_alert_handler.dart';
import '../../../kyc/kyc_service.dart';
import '../../../kyc/models/kyc_operation_status_model.dart';
import '../../../payment_methods/ui/widgets/add_button.dart';
import '../../../payment_methods/ui/widgets/card_limit.dart';
import '../../../payment_methods/ui/widgets/payment_card_item.dart';
import '../../helper/formatted_circle_card.dart';
import '../../store/payment_methods_store.dart';
import 'add_bank_card.dart';

@RoutePage(name: 'PaymentMethodRouter')
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<PaymentMethodsScreenStore>(
      create: (context) => PaymentMethodsScreenStore(currency),
      builder: (context, child) => _PaymentMethodScreen(
        currency: currency,
      ),
    );
  }
}

class _PaymentMethodScreen extends StatefulObserverWidget {
  const _PaymentMethodScreen({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<_PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<_PaymentMethodScreen> {
  bool analyticSent = false;

  @override
  void initState() {
    super.initState();
    final store = PaymentMethodsScreenStore.of(context);

    store.initDefaultPaymentMethod(fromCard: true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final state = PaymentMethodsScreenStore.of(context);
    final kycState = getIt.get<KycService>();
    final kycHandler = getIt.get<KycAlertHandler>();
    final cardLimit = sSignalRModules.cardLimitsModel;

    final unlimintIncludes = widget.currency.buyMethods.where(
      (element) => element.id == PaymentMethodType.unlimintCard,
    );

    final unlimintAltIncludes = widget.currency.buyMethods.where(
      (element) => element.id == PaymentMethodType.bankCard,
    );

    final isUnlimintCardEnabled = widget.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList()
        .isNotEmpty;

    final showSubheader = widget.currency.buyMethods.isNotEmpty &&
        !(widget.currency.buyMethods.length == 1 &&
            widget.currency.buyMethods[0].id == PaymentMethodType.bankCard);

    final isLimitBlock = cardLimit?.day1State == StateLimitType.block ||
        cardLimit?.day7State == StateLimitType.block ||
        cardLimit?.day30State == StateLimitType.block;

    final isEmptyPaymentScreen = widget.currency.buyMethods.length == 1 &&
        widget.currency.buyMethods[0].id == PaymentMethodType.bankCard &&
        state.unlimintAltCards.isEmpty;

    final isEmptyPaymentCards = state.circleCards.isEmpty &&
        !(state.unlimintCards.isNotEmpty && unlimintIncludes.isNotEmpty) &&
        !(state.unlimintAltCards.isNotEmpty && unlimintAltIncludes.isNotEmpty);

    void showDeleteDisclaimer({required VoidCallback onDelete}) {
      sAnalytics.newBuyTapDelete();
      sAnalytics.newBuyDeleteView();

      return sShowAlertPopup(
        context,
        primaryText: '${intl.paymentMethod_showAlertPopupPrimaryText}?',
        secondaryText: '${intl.paymentMethod_showAlertPopupSecondaryFullText}?',
        primaryButtonName: intl.paymentMethod_yesDelete,
        secondaryButtonName: intl.paymentMethod_cancel,
        primaryButtonType: SButtonType.primary3,
        onPrimaryButtonTap: onDelete,
        onSecondaryButtonTap: () {
          sAnalytics.newBuyTapCancelDelete();
          Navigator.pop(context);
        },
      );
    }

    if (!analyticSent && isEmptyPaymentCards) {
      analyticSent = true;
      sAnalytics.newBuyNoSavedCard();
    }

    void onAddCardTap() {
      final kycState = getIt.get<KycService>();
      final status = kycOperationStatus(KycStatus.kycRequired);
      final isUserVerified = kycState.depositStatus != status &&
          kycState.sellStatus != status &&
          kycState.withdrawalStatus != status;
      sAnalytics.newBuyEnterCardDetailsView(nameVisible: '${!isUserVerified}');
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.white,
          pageBuilder: (BuildContext context, _, __) {
            return AddBankCard(
              onCardAdded: () {},
              amount: '',
              isPreview: true,
              currency: widget.currency,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }

    void checkKyc() {
      sAnalytics.newBuyTapAddCard();
      final status = kycOperationStatus(KycStatus.allowed);
      if (kycState.depositStatus == status) {
        onAddCardTap();
      } else {
        kycHandler.handle(
          status: kycState.depositStatus,
          isProgress: kycState.verificationInProgress,
          currentNavigate: () => onAddCardTap(),
          requiredDocuments: kycState.requiredDocuments,
          requiredVerifications: kycState.requiredVerifications,
        );
      }
    }

    Widget paymentMethods() {
      return Column(
        children: [
          if (widget.currency.buyMethods.isNotEmpty &&
              !(widget.currency.buyMethods.length == 1 &&
                  widget.currency.buyMethods.first.id ==
                      PaymentMethodType.bankCard)) ...[
            for (final method in widget.currency.buyMethods)
              if (method.id == PaymentMethodType.simplex) ...[
                Builder(
                  builder: (context) {
                    return SActionItem(
                      icon: SizedBox(
                        width: 40,
                        height: 25,
                        child: Center(
                          child: SActionDepositIcon(
                            color: sKit.colors.blue,
                          ),
                        ),
                      ),
                      isSelected: state.selectedPaymentMethod?.id ==
                          PaymentMethodType.simplex,
                      name: intl.currencyBuy_card,
                      description: intl.curencyBuy_actionItemDescription,
                      onTap: () {
                        sAnalytics.newBuyBuyAssetView(
                          asset: widget.currency.symbol,
                        );
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: method.id,
                          ),
                        );
                      },
                    );
                  },
                ),
              ] else if (method.id == PaymentMethodType.circleCard) ...[
                SActionItem(
                  icon: SizedBox(
                    width: 40,
                    height: 25,
                    child: Center(
                      child: SActionDepositIcon(
                        color: sKit.colors.blue,
                      ),
                    ),
                  ),
                  name: intl.currencyBuy_card,
                  description: intl.curencyBuy_actionItemDescription,
                  isSelected: state.selectedPaymentMethod?.id ==
                          PaymentMethodType.circleCard &&
                      state.pickedCircleCard == null,
                  onTap: () {
                    sRouter.navigate(
                      AddCircleCardRouter(
                        onCardAdded: (card) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          state.onCircleCardAdded(card);
                        },
                      ),
                    );
                  },
                ),
              ] else if (method.id == PaymentMethodType.unlimintCard) ...[
                Builder(
                  builder: (context) {
                    return SActionItem(
                      icon: SizedBox(
                        width: 40,
                        height: 25,
                        child: Center(
                          child: SActionDepositIcon(
                            color: sKit.colors.blue,
                          ),
                        ),
                      ),
                      isSelected: state.selectedPaymentMethod?.id ==
                              PaymentMethodType.unlimintCard &&
                          state.pickedUnlimintCard == null,
                      name: intl.currencyBuy_card,
                      description:
                          intl.curencyBuy_actionItemDescriptionWithoutApplePay,
                      onTap: () {
                        sAnalytics.newBuyBuyAssetView(
                          asset: widget.currency.symbol,
                        );
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: method.id,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            const SpaceH16(),
          ],
        ],
      );
    }

    Widget savedCards() {
      return Column(
        children: [
          if (showSubheader)
            ActionBuySubheader(
              text: intl.actionBuy_cards,
            ),
          if (state.circleCards.isNotEmpty) ...[
            for (final card in state.circleCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return PaymentCardItem(
                    name: formatted.last4Digits,
                    network: card.network,
                    expirationDate: card.status == CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : formatted.expDate,
                    expired: cardLimit?.barProgress == 100 || isLimitBlock,
                    status: card.status,
                    showDelete: state.editMode,
                    onDelete: () => showDeleteDisclaimer(
                      onDelete: () async {
                        await sRouter.pop();
                        await state.deleteCard(card);
                      },
                    ),
                    onTap: () {
                      if (cardLimit?.barProgress != 100 &&
                          !isLimitBlock &&
                          !state.editMode) {
                        sAnalytics.newBuyBuyAssetView(
                          asset: widget.currency.symbol,
                        );
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: PaymentMethodType.circleCard,
                            circleCard: card,
                          ),
                        );
                      }
                    },
                    removeDivider: true,
                  );
                },
              ),
          ],
          if (state.unlimintCards.isNotEmpty &&
              unlimintIncludes.isNotEmpty) ...[
            for (final card in state.unlimintCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return PaymentCardItem(
                    name: formatted.last4Digits,
                    network: card.network,
                    expirationDate: card.status == CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : formatted.expDate,
                    expired: cardLimit?.barProgress == 100 || isLimitBlock,
                    status: card.status,
                    showDelete: state.editMode,
                    onDelete: () => showDeleteDisclaimer(
                      onDelete: () async {
                        await sRouter.pop();
                        await state.deleteCard(card);
                      },
                    ),
                    onTap: () {
                      if (cardLimit?.barProgress != 100 &&
                          !isLimitBlock &&
                          !state.editMode) {
                        sAnalytics.newBuyBuyAssetView(
                          asset: widget.currency.symbol,
                        );
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: PaymentMethodType.unlimintCard,
                            unlimintCard: card,
                          ),
                        );
                      }
                    },
                    removeDivider: true,
                  );
                },
              ),
            const SpaceH10(),
          ],
          if (state.unlimintAltCards.isNotEmpty &&
              unlimintAltIncludes.isNotEmpty) ...[
            for (final card in state.unlimintAltCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return PaymentCardItem(
                    name: formatted.last4Digits,
                    network: card.network,
                    expirationDate: card.status == CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : formatted.expDate,
                    expired: cardLimit?.barProgress == 100 || isLimitBlock,
                    status: card.status,
                    showDelete: state.editMode,
                    onDelete: () => showDeleteDisclaimer(
                      onDelete: () async {
                        await sRouter.pop();
                        await state.deleteCard(card);
                      },
                    ),
                    onTap: () {
                      if (cardLimit?.barProgress != 100 &&
                          !isLimitBlock &&
                          !state.editMode) {
                        sAnalytics.newBuyBuyAssetView(
                          asset: widget.currency.symbol,
                        );
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: PaymentMethodType.bankCard,
                            bankCard: card,
                          ),
                        );
                      }
                    },
                    removeDivider: true,
                  );
                },
              ),
          ],
          if (isUnlimintCardEnabled)
            SCreditCardItem(
              icon: SizedBox(
                width: 40,
                height: 25,
                child: Center(
                  child: SPlusIcon(
                    color: colors.blue,
                  ),
                ),
              ),
              name: intl.actionBuy_addACard,
              amount: '',
              helper: intl.depositOptions_actionItemDescription1,
              description: '',
              removeDivider: true,
              onTap: () {
                checkKyc();
              },
            ),
        ],
      );
    }

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.paymentMethods_paymentMethods,
          onBackButtonTap: () => Navigator.pop(context),
          showEditButton: !isEmptyPaymentCards && !state.editMode,
          showDoneButton: !isEmptyPaymentCards && state.editMode,
          onEditButtonTap: () {
            sAnalytics.newBuyTapEdit();
            state.toggleEditMode();
          },
          onDoneButtonTap: () {
            state.toggleEditMode();
          },
        ),
      ),
      child: state.editMode
          ? Column(
              children: [
                savedCards(),
              ],
            )
          : isEmptyPaymentScreen
              ? Column(
                  children: [
                    const Spacer(),
                    Image.asset(
                      noSavedCards,
                      height: 80,
                    ),
                    const SpaceH32(),
                    Text(intl.paymentMethods_noSavedCards, style: sTextH3Style),
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
                    const Spacer(),
                    if (isUnlimintCardEnabled)
                      SPaddingH24(
                        child: AddButton(
                          onTap: () => checkKyc(),
                        ),
                      ),
                    const SpaceH42(),
                  ],
                )
              : !isEmptyPaymentCards
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          paymentMethods(),
                          savedCards(),
                          const SpaceH42(),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        paymentMethods(),
                        savedCards(),
                        if (isEmptyPaymentCards) ...[
                          const Spacer(),
                          Image.asset(
                            noSavedCards,
                            height: 80,
                          ),
                          const SpaceH32(),
                          Text(
                            intl.paymentMethods_noSavedCards,
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
                          const Spacer(),
                        ],
                      ],
                    ),
    );
  }
}
