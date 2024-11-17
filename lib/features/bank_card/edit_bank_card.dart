import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/bank_card/store/bank_card_store.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_cardnumber.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_date_label.dart';
import 'package:jetwallet/features/bank_card/widgets/bank_card_holdername.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

class EditBankCardScreen extends StatelessWidget {
  const EditBankCardScreen({
    super.key,
    required this.card,
  });

  final CircleCard card;

  @override
  Widget build(BuildContext context) {
    return Provider<BankCardStore>(
      create: (context) => BankCardStore()
        ..init(
          BankCardStoreMode.edit,
          card: card,
        ),
      builder: (context, child) => _EditBankCardScreenBody(card: card),
    );
  }
}

class _EditBankCardScreenBody extends StatelessObserverWidget {
  const _EditBankCardScreenBody({
    required this.card,
  });

  final CircleCard card;

  @override
  Widget build(BuildContext context) {
    final store = BankCardStore.of(context);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      resizeToAvoidBottomInset: false,
      color: sKit.colors.grey5,
      loading: store.loader,
      header: GlobalBasicAppBar(
        title: intl.editCircleCard_bigHeaderTitle,
        hasLeftIcon: false,
        onRightIconTap: () => sRouter.maybePop(),
      ),
      child: Column(
        children: [
          const BankCardHolderName(),
          const BankCardCardnumber(),
          const BankCardDateLabel(),
          const Spacer(),
          SPaddingH24(
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: SButton.black(
                    text: intl.addCircleCard_save_changes,
                    callback: store.isEditButtonSaveActive
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

                            await store.updateCardLabel(card.id);
                          }
                        : null,
                  ),
                ),
                const SpaceH10(),
                STextButton1(
                  active: true,
                  name: intl.addCircleCard_delete,
                  onTap: () {
                    showDeleteDisclaimer(
                      context,
                      onDelete: () async {
                        await sRouter.maybePop();
                        await store.deleteCard(card);

                        store.loader.finishLoadingImmediately();

                        await sRouter.maybePop();
                      },
                    );
                  },
                ),
                const SpaceH42(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showDeleteDisclaimer(
  BuildContext context, {
  required VoidCallback onDelete,
}) {
  return sShowAlertPopup(
    context,
    primaryText: '${intl.paymentMethod_showAlertPopupPrimaryText}?',
    secondaryText: '${intl.paymentMethod_showAlertPopupSecondaryDescrText}?',
    primaryButtonName: intl.paymentMethod_yesDelete,
    secondaryButtonName: intl.paymentMethod_cancel,
    isPrimaryButtonRed: true,
    onPrimaryButtonTap: onDelete,
    onSecondaryButtonTap: () => Navigator.pop(context),
  );
}
