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
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
            const Spacer(),
            VisibilityDetector(
              key: const Key('transfer-flow-widget-key'),
              onVisibilityChanged: (visibilityInfo) {
                if (visibilityInfo.visibleFraction != 1) return;
              },
              child: SNewActionPriceField(
                widgetSize: widgetSizeFrom(deviceSize),
                primaryAmount: formatCurrencyStringAmount(
                  value: store.inputValue,
                ),
                primarySymbol: 'EUR',
                errorText: store.errorText,
                onSwap: () {},
                optionOnTap: () {},
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
              ),
            ),
            const Spacer(),
            _AsssetWidget(
              card: store.fromCard,
              account: store.fromAccount,
              onTap: () {
                showTransferFromToBottomSheet(
                  context: context,
                  isFrom: true,
                  onSelected: ({SimpleBankingAccount? newAccount, CardDataModel? newCard}) {
                    store.setNewFromAsset(
                      newFromCard: newCard,
                      newFromAccount: newAccount,
                    );
                  },
                  skipId: store.toAccount?.accountId ?? store.toCard?.cardId,
                );
              },
              isFrom: true,
            ),
            const SpaceH8(),
            _AsssetWidget(
              card: store.toCard,
              account: store.toAccount,
              onTap: () {
                showTransferFromToBottomSheet(
                  context: context,
                  isFrom: false,
                  onSelected: ({SimpleBankingAccount? newAccount, CardDataModel? newCard}) {
                    store.setNewToAsset(
                      newToCard: newCard,
                      newToAccount: newAccount,
                    );
                  },
                  skipId: store.fromAccount?.accountId ?? store.fromCard?.cardId,
                );
              },
              isFrom: false,
            ),
            const SpaceH20(),
            SNumericKeyboardAmount(
              widgetSize: widgetSizeFrom(deviceSize),
              onKeyPressed: (value) {
                store.updateInputValue(value);
              },
              buttonType: SButtonType.primary2,
              submitButtonActive: store.isContinueAvaible,
              submitButtonName: intl.addCircleCard_continue,
              onSubmitPressed: () {
                sRouter.push(
                  TransferConfirmationRoute(
                    fromCard: store.fromCard,
                    toCard: store.toCard,
                    fromAccount: store.fromAccount,
                    toAccount: store.toAccount,
                    amount: Decimal.parse(store.inputValue),
                  ),
                );
              },
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
  });

  final CardDataModel? card;
  final SimpleBankingAccount? account;
  final void Function() onTap;
  final bool isFrom;

  @override
  Widget build(BuildContext context) {
    return SuggestionButtonWidget(
      title: account?.label ?? card?.label,
      subTitle: isFrom ? intl.from : intl.to1,
      trailing: account == null && card == null
          ? null
          : volumeFormat(
              decimal: account?.balance ?? card?.balance ?? Decimal.zero,
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
    );
  }
}