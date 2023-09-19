import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_cardnumber.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_date_label.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_holdername.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class AddBankCardScreen extends StatelessWidget {
  const AddBankCardScreen({
    super.key,
    required this.onCardAdded,
    required this.amount,
    this.currency,
    this.isPreview = false,
    this.method,
    this.asset,
  });

  final Function() onCardAdded;
  final String amount;
  final PaymentAsset? currency;
  final bool isPreview;

  final BuyMethodDto? method;
  final CurrencyModel? asset;

  @override
  Widget build(BuildContext context) {
    return Provider<BankCardStore>(
      create: (context) => BankCardStore()..init(BankCardStoreMode.add),
      builder: (context, child) => _AddBankCardScreenBody(
        onCardAdded: onCardAdded,
        amount: amount,
        currency: currency,
        isPreview: isPreview,
        method: method,
        asset: asset,
      ),
    );
  }
}

class _AddBankCardScreenBody extends StatelessObserverWidget {
  const _AddBankCardScreenBody({
    required this.onCardAdded,
    required this.amount,
    this.currency,
    this.isPreview = false,
    this.method,
    this.asset,
  });

  final Function() onCardAdded;
  final String amount;
  final PaymentAsset? currency;
  final bool isPreview;
  final BuyMethodDto? method;
  final CurrencyModel? asset;

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
          onCLoseButton: () => sRouter.pop(),
          showCloseButton: true,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const BankCardHolderName(),
            const BankCardCardnumber(),
            const BankCardDateLabel(),
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
                                  store.checkSetter();
                                },
                                defaultIcon: store.saveCard
                                    ? const SCheckboxSelectedIcon()
                                    : const SCheckboxIcon(),
                                pressedIcon: store.saveCard
                                    ? const SCheckboxSelectedIcon()
                                    : const SCheckboxIcon(),
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
                    child: SPrimaryButton2(
                      active: store.isCardDetailsValid,
                      name: intl.addCircleCard_continue,
                      onTap: () async {
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
                          currency: currency,
                          method: method,
                          asset: asset!,
                        );
                      },
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
