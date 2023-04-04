import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/payment_methods/store/payment_methods_store.dart';
import 'package:jetwallet/features/payment_methods/ui/widgets/add_button.dart';
import 'package:jetwallet/features/payment_methods/ui/widgets/card_limit.dart';
import 'package:jetwallet/features/payment_methods/ui/widgets/payment_card_item.dart';
import 'package:jetwallet/utils/helpers/is_card_expired.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

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
  const _PaymentMethodsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final loader = StackLoaderStore();

    final kycState = getIt.get<KycService>();
    final cardLimitsState = sSignalRModules.cardLimitsModel;
    final kycHandler = getIt.get<KycAlertHandler>();
    final allPaymentMethods = sSignalRModules.paymentMethods;
    final useCircleCard =
        allPaymentMethods.contains('PaymentMethodType.circleCard');

    final state = PaymentMethodsStore.of(context);

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

    void _onAddCardTap() {
      if (useCircleCard) {
        sRouter.push(
          AddCircleCardRouter(
            onCardAdded: (_) {
              Navigator.pop(context);
              Navigator.pop(context);
              state.getCards();
            },
          ),
        );
      }
    }

    void checkKyc() {
      final status = kycOperationStatus(KycStatus.allowed);
      if (kycState.depositStatus == status) {
        _onAddCardTap();
      } else {
        kycHandler.handle(
          status: kycState.depositStatus,
          isProgress: kycState.verificationInProgress,
          currentNavigate: () => _onAddCardTap(),
          requiredDocuments: kycState.requiredDocuments,
          requiredVerifications: kycState.requiredVerifications,
        );
      }
    }

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
          return state.cards.isEmpty
              ? Column(
                  children: [
                    const Spacer(),
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
                    if (useCircleCard)
                      SPaddingH24(
                        child: AddButton(
                          onTap: () => checkKyc(),
                        ),
                      ),
                    const SpaceH24(),
                  ],
                )
              : Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      children: [
                        for (final card in state.cards)
                          PaymentCardItem(
                            name: '${card.network} •••• ${card.last4}',
                            network: card.network,
                            expirationDate:
                                'Exp. ${card.expMonth}/${card.expYear}',
                            expired: isCardExpired(card.expMonth, card.expYear),
                            status: card.status,
                            onDelete: () => showDeleteDisclaimer(
                              onDelete: () async {
                                loader.startLoading();
                                await sRouter.pop();
                                await state.deleteCard(card);

                                loader.finishLoading();
                              },
                            ),
                            removeDivider: true,
                            onTap: () {},
                          ),
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
