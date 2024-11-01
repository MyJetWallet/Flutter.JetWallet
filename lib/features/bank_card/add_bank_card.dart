import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/bank_card/bank_card_lable.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_cardnumber.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_date_label.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_holdername.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class AddBankCardScreen extends StatefulWidget {
  const AddBankCardScreen({
    super.key,
    required this.onCardAdded,
    required this.amount,
    this.isPreview = false,
    this.asset,
    this.divideDateAndLabel = false,
  });

  final Function() onCardAdded;
  final String amount;
  final bool isPreview;
  final bool divideDateAndLabel;

  final CurrencyModel? asset;

  @override
  State<AddBankCardScreen> createState() => _AddBankCardScreenState();
}

class _AddBankCardScreenState extends State<AddBankCardScreen> {
  @override
  void initState() {
    sAnalytics.addCardDetailsScreenView(
      destinationWallet: widget.asset?.symbol ?? '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<BankCardStore>(
      create: (context) => BankCardStore()..init(BankCardStoreMode.add),
      builder: (context, child) => _AddBankCardScreenBody(
        onCardAdded: widget.onCardAdded,
        amount: widget.amount,
        isPreview: widget.isPreview,
        asset: widget.asset,
        divideDateAndLabel: widget.divideDateAndLabel,
      ),
    );
  }
}

class _AddBankCardScreenBody extends StatelessObserverWidget {
  const _AddBankCardScreenBody({
    required this.onCardAdded,
    required this.amount,
    this.isPreview = false,
    this.asset,
    required this.divideDateAndLabel,
  });

  final Function() onCardAdded;
  final String amount;
  final bool isPreview;
  final CurrencyModel? asset;
  final bool divideDateAndLabel;

  @override
  Widget build(BuildContext context) {
    final store = BankCardStore.of(context);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      color: sKit.colors.grey5,
      loading: store.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.addCircleCard_bigHeaderTitle,
          showBackButton: false,
          onCLoseButton: () {
            sRouter.maybePop();
          },
          showCloseButton: true,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const BankCardHolderName(),
            const BankCardCardnumber(),
            BankCardDateLabel(
              showLabel: !divideDateAndLabel,
            ),
            const Spacer(),
            Container(
              color: sKit.colors.grey5,
              height: 144,
              child: Column(
                children: [
                  if (isPreview) ...[
                    const SpaceH12(),
                    SPaddingH24(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SIconButton(
                                onTap: () {
                                  sAnalytics.tapOnSaveCardForFurtherPurchaseButton(
                                    destinationWallet: asset?.symbol ?? '',
                                  );
                                  store.checkSetter();
                                },
                                defaultIcon: store.saveCard ? const SCheckboxSelectedIcon() : const SCheckboxIcon(),
                                pressedIcon: store.saveCard ? const SCheckboxSelectedIcon() : const SCheckboxIcon(),
                              ),
                            ],
                          ),
                          const SpaceW10(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 82,
                            child: SPolicyText(
                              firstText: intl.addCircleCard_saveCard,
                              userAgreementText: '',
                              betweenText: '',
                              privacyPolicyText: '',
                              onUserAgreementTap: () {},
                              onPrivacyPolicyTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  ContinueButtonFrame(
                    child: SButton.blue(
                      text: intl.addCircleCard_continue,
                      callback: store.isCardDetailsValid
                          ? () async {
                              sAnalytics.tapOnContinueCrNewCardButton(
                                destinationWallet: asset?.symbol ?? '',
                              );
                              if (store.saveCard) {
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    barrierColor: Colors.white,
                                    pageBuilder: (BuildContext _, __, ___) {
                                      return BankCardLabel(
                                        contextWithBankCardStore: context,
                                        amount: amount,
                                        onCardAdded: onCardAdded,
                                        asset: asset,
                                        isPreview: isPreview,
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
                                );
                              } else {
                                if (store.canClick) {
                                  store.setCanClick(false);
                                  Timer(
                                    const Duration(
                                      seconds: 2,
                                    ),
                                    () => store.setCanClick(true),
                                  );
                                } else {
                                  return;
                                }

                                await store.addCard(
                                  onSuccess: onCardAdded,
                                  onError: () {},
                                  isPreview: isPreview,
                                  amount: amount,
                                  asset: asset!,
                                );
                              }
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceH16(),
          ],
        ),
      ),
    );
  }
}
