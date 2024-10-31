import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class BankCardLabel extends StatelessObserverWidget {
  const BankCardLabel({
    super.key,
    required this.contextWithBankCardStore,
    required this.onCardAdded,
    required this.amount,
    this.currency,
    this.isPreview = false,
    this.asset,
  });

  final BuildContext contextWithBankCardStore;
  final Function() onCardAdded;
  final String amount;
  final PaymentAsset? currency;
  final bool isPreview;
  final CurrencyModel? asset;

  @override
  Widget build(BuildContext context) {
    final store = BankCardStore.of(contextWithBankCardStore);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      color: sKit.colors.grey5,
      loading: store.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.bank_card_leable_headet,
          onBackButtonTap: () {
            sRouter.maybePop();
          },
        ),
      ),
      child: Column(
        children: [
          SFieldDividerFrame(
            child: SStandardField(
              maxLines: 1,
              maxLength: 30,
              labelText: intl.addCircleCard_label,
              autofocus: true,
              isError: store.labelError,
              enableInteractiveSelection: false,
              disableErrorOnChanged: false,
              controller: store.cardLabelController,
              onChanged: store.setCardLabel,
            ),
          ),
          const Spacer(),
          ContinueButtonFrame(
            child: SButton.blue(
              text: intl.addCircleCard_continue,
              callback: store.isLabelValid
                  ? () async {
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
                        asset: asset!,
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
