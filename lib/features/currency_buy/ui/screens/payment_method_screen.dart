import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

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
          (element) => element.type == PaymentMethodType.unlimintCard,
    );

    final unlimintAltIncludes = widget.currency.buyMethods.where(
          (element) => element.type == PaymentMethodType.bankCard,
    );

    final isUnlimintCardEnabled = widget.currency.buyMethods.where(
      (element) => element.type == PaymentMethodType.bankCard,
    ).toList().isNotEmpty;

    final isLimitBlock = cardLimit?.day1State == StateLimitType.block ||
        cardLimit?.day7State == StateLimitType.block ||
        cardLimit?.day30State == StateLimitType.block;

    final isEmptyPaymentScreen = widget.currency.buyMethods.length == 1 &&
        widget.currency.buyMethods[0].type == PaymentMethodType.bankCard &&
        state.unlimintAltCards.isEmpty;

    final isEmptyPaymentCards = state.circleCards.isEmpty &&
        !(state.unlimintCards.isNotEmpty &&
            unlimintIncludes.isNotEmpty) &&
        !(state.unlimintAltCards.isNotEmpty &&
          unlimintAltIncludes.isNotEmpty);

    void showDeleteDisclaimer({required VoidCallback onDelete}) {
      return sShowAlertPopup(
        context,
        primaryText: '${intl.paymentMethod_showAlertPopupPrimaryText}?',
        secondaryText: '${intl.paymentMethod_showAlertPopupSecondaryFullText}?',
        primaryButtonName: intl.paymentMethod_yesDelete,
        secondaryButtonName: intl.paymentMethod_cancel,
        primaryButtonType: SButtonType.primary3,
        onPrimaryButtonTap: onDelete,
        onSecondaryButtonTap: () => Navigator.pop(context),
      );
    }

    void onAddCardTap() {
      sShowBasicModalBottomSheet(
        context: context,
        scrollable: true,
        pinned: SPaddingH24(
          child: SSmallHeader(
            title: intl.addCircleCard_bigHeaderTitle,
            showBackButton: false,
            onCLoseButton: () {
              sRouter.pop();
            },
            showCloseButton: true,
          ),
        ),
        horizontalPinnedPadding: 0.0,
        removePinnedPadding: true,
        removeBottomSheetBar: true,
        removeBarPadding: true,
        expanded: true,
        fullScreen: true,
        children: [
          AddBankCard(
            onCardAdded: () {},
            amount: '',
            isPreview: true,
          ),
        ],
      );
    }

    Widget paymentMethods() {
      return Column(
        children: [
          if (widget.currency.buyMethods.isNotEmpty &&
              !(widget.currency.buyMethods.length == 1 &&
                  widget.currency.buyMethods.first.type ==
                      PaymentMethodType.bankCard)) ...[
            for (final method in widget.currency.buyMethods)
              if (method.type == PaymentMethodType.simplex) ...[
                Builder(
                  builder: (context) {
                    return SActionItem(
                      icon: SActionDepositIcon(
                        color: colors.blue,
                      ),
                      isSelected: state.selectedPaymentMethod?.type ==
                          PaymentMethodType.simplex,
                      name: intl.currencyBuy_card,
                      description: intl.curencyBuy_actionItemDescription,
                      onTap: () {
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: method.type,
                          ),
                        );
                      },
                    );
                  },
                ),
              ] else if (method.type == PaymentMethodType.circleCard) ...[
                SActionItem(
                  icon: SActionDepositIcon(
                    color: colors.blue,
                  ),
                  name: intl.currencyBuy_card,
                  description: intl.curencyBuy_actionItemDescription,
                  isSelected: state.selectedPaymentMethod?.type ==
                      PaymentMethodType.circleCard &&
                      state.pickedCircleCard == null,
                  onTap: () {
                    sAnalytics.circleTapAddCard();
                    sAnalytics.paymentDetailsView(source: 'Circle');

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
              ] else if (method.type == PaymentMethodType.unlimintCard) ...[
                Builder(
                  builder: (context) {
                    return SActionItem(
                      icon: SActionDepositIcon(
                        color: colors.blue,
                      ),
                      isSelected: state.selectedPaymentMethod?.type ==
                          PaymentMethodType.unlimintCard &&
                          state.pickedUnlimintCard == null,
                      name: intl.currencyBuy_card,
                      description:
                      intl.curencyBuy_actionItemDescriptionWithoutApplePay,
                      onTap: () {
                        sRouter.push(
                          CurrencyBuyRouter(
                            currency: widget.currency,
                            fromCard: true,
                            paymentMethod: method.type,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
          ],
          const SpaceH16(),
        ],
      );
    }

    Widget savedCards() {
      return Column(
        children: [
          ActionBuySubheader(
            text: intl.actionBuy_cards,
          ),
          if (cardLimit != null && !state.editMode) ...[
            const SpaceH12(),
            CardLimit(
              cardLimit: cardLimit,
              small: true,
            ),
            const SpaceH12(),
          ],
          if (cardLimit == null || state.editMode) const SpaceH16(),
          if (state.circleCards.isNotEmpty) ...[
            for (final card in state.circleCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return PaymentCardItem(
                    name: '${formatted.name} ${formatted.last4Digits}',
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
                      if (cardLimit?.barProgress != 100 && !isLimitBlock) {
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
                    name: '${formatted.name} ${formatted.last4Digits}',
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
                      if (cardLimit?.barProgress != 100 && !isLimitBlock) {
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
                    name: '${formatted.name} ${formatted.last4Digits}',
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
                      if (cardLimit?.barProgress != 100 && !isLimitBlock) {
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
          SCreditCardItem(
            icon: SPlusIcon(
              color: colors.blue,
            ),
            name: intl.actionBuy_addACard,
            amount: '',
            helper: intl.depositOptions_actionItemDescription1,
            description: '',
            removeDivider: true,
            onTap: () {
              onAddCardTap();
            },
          ),
        ],
      );
    }

    void checkKyc() {
      sAnalytics.paymentAdd();
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

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.paymentMethods_paymentMethods,
          onBackButtonTap: () => Navigator.pop(context),
          showEditButton: !isEmptyPaymentCards && !state.editMode,
          showDoneButton: !isEmptyPaymentCards && state.editMode,

          onEditButtonTap: () {
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
        : isEmptyPaymentScreen ? Column(
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
      ) : !isEmptyPaymentCards
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
                  const SpaceH94(),
                  const Spacer(),
                ],
              ],
            ),
    );
  }
}
