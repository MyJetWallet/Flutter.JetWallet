import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/transfer_flow/store/transfer_amount_store.dart';
import 'package:jetwallet/features/transfer_flow/widgets/show_transfer_from_to_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

class TransferAmountTabBody extends StatefulWidget {
  const TransferAmountTabBody({
    super.key,
    this.fromCard,
    this.toCard,
    this.fromAccount,
    this.toAccount,
  });

  final CardDataModel? fromCard;
  final CardDataModel? toCard;
  final SimpleBankingAccount? fromAccount;
  final SimpleBankingAccount? toAccount;

  @override
  State<TransferAmountTabBody> createState() => _TransferAmountTabBodyState();
}

class _TransferAmountTabBodyState extends State<TransferAmountTabBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Provider<TransfetAmountStore>(
      create: (context) => TransfetAmountStore()
        ..init(
          newFromCard: widget.fromCard,
          newToCard: widget.toCard,
          newFromAccount: widget.fromAccount,
          newToAccount: widget.toAccount,
        ),
      builder: (context, child) => const _TrancferBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _TrancferBody extends StatelessWidget {
  const _TrancferBody();

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    final store = TransfetAmountStore.of(context);

    return Observer(
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        deviceSize.when(
                          small: () => const SpaceH40(),
                          medium: () => const Spacer(),
                        ),
                        SNumericLargeInput(
                          primaryAmount: formatCurrencyStringAmount(
                            value: store.inputValue,
                          ),
                          primarySymbol: 'EUR',
                          errorText: store.errorText,
                          onSwap: () {},
                          pasteLabel: intl.paste,
                          onPaste: () async {
                            final data = await Clipboard.getData('text/plain');
                            if (data?.text != null) {
                              final n = double.tryParse(data!.text!);
                              if (n != null) {
                                store.pasteValue(n.toString());
                              }
                            }
                          },
                          showMaxButton: true,
                          onMaxTap: () {
                            store.onTransfetAll();
                          },
                          showSwopButton: false,
                        ),
                        const Spacer(),
                        _AsssetWidget(
                          card: store.fromCard,
                          account: store.fromAccount,
                          onTap: () {
                            sAnalytics.tapOnTheTransferFromButton(
                              currentFromValueForTransfer: store.fromType?.analyticsValue ?? 'none',
                            );
                            sAnalytics.transferFromSheetView();
                            showTransferFromToBottomSheet(
                              context: context,
                              isFrom: true,
                              onSelected: ({
                                SimpleBankingAccount? newAccount,
                                CardDataModel? newCard,
                              }) {
                                store.setNewFromAsset(
                                  newFromCard: newCard,
                                  newFromAccount: newAccount,
                                );
                                sAnalytics.tapOnSelectedNewTransferFromAccountButton(
                                  newTransferFromAccount: store.fromType?.analyticsValue ?? 'none',
                                );
                              },
                              skipId: store.toAccount?.accountId ?? store.toCard?.cardId,
                              fromType: store.fromType,
                              toType: store.toType,
                            );
                          },
                          isFrom: true,
                        ),
                        const SpaceH4(),
                        _AsssetWidget(
                          card: store.toCard,
                          account: store.toAccount,
                          onTap: () {
                            sAnalytics.tapOnTheTransferToButton(
                              currentToValueForTransfer: store.toType?.analyticsValue ?? 'none',
                            );
                            sAnalytics.transferToSheetView();
                            showTransferFromToBottomSheet(
                              context: context,
                              isFrom: false,
                              onSelected: ({
                                SimpleBankingAccount? newAccount,
                                CardDataModel? newCard,
                              }) {
                                store.setNewToAsset(
                                  newToCard: newCard,
                                  newToAccount: newAccount,
                                );
                                sAnalytics.tapOnSelectedNewTransferToButton(
                                  newTransferToAccount: store.toType?.analyticsValue ?? 'none',
                                );
                              },
                              skipId: store.fromAccount?.accountId ?? store.fromCard?.cardId,
                              fromType: store.fromType,
                              toType: store.toType,
                            );
                          },
                          isFrom: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SNumericKeyboard(
              onKeyPressed: (value) {
                store.updateInputValue(value);
              },
              button: SButton.black(
                text: intl.addCircleCard_continue,
                callback: store.isContinueAvaible
                    ? () {
                        sAnalytics.tapOnTheContinueWithTransferAmountButton(
                          transferFrom: store.fromType?.analyticsValue ?? 'none',
                          transferTo: store.toType?.analyticsValue ?? 'none',
                          enteredAmount: store.inputValue,
                        );
                        sRouter.push(
                          TransferConfirmationRoute(
                            fromCard: store.fromCard,
                            toCard: store.toCard,
                            fromAccount: store.fromAccount,
                            toAccount: store.toAccount,
                            amount: Decimal.parse(store.inputValue),
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AsssetWidget extends StatelessWidget {
  const _AsssetWidget({
    this.account,
    this.card,
    required this.onTap,
    required this.isFrom,
    // ignore: unused_element
    this.isDisabled = false,
  });

  final CardDataModel? card;
  final SimpleBankingAccount? account;
  final void Function() onTap;
  final bool isFrom;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SuggestionButtonWidget(
      title: account?.label ?? card?.label,
      subTitle: isFrom ? intl.from : intl.to1,
      trailing: account == null && card == null
          ? null
          : getIt<AppStore>().isBalanceHide
              ? '**** ${account?.currency}'
              : (account?.balance ?? card?.balance ?? Decimal.zero).toFormatSum(
                  accuracy: 2,
                  symbol: account?.currency ?? card?.currency ?? '',
                ),
      icon: account != null
          ? Assets.svg.other.medium.bankAccount.simpleSvg(
              width: 24,
            )
          : card != null
              ? Assets.svg.assets.fiat.cardAlt.simpleSvg(
                  width: 24,
                )
              : Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: sKit.colors.grey1,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SBankMediumIcon(color: sKit.colors.white),
                  ),
                ),
      onTap: onTap,
      isDisabled: isDisabled,
    );
  }
}
