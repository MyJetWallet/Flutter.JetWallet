import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:jetwallet/features/currency_buy/store/add_bank_card_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class AddBankCard extends StatelessWidget {
  const AddBankCard({
    Key? key,
    required this.onCardAdded,
    required this.amount,
    this.currency,
    this.isPreview = false,
  }) : super(key: key);

  final Function() onCardAdded;
  final String amount;
  final CurrencyModel? currency;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    return Provider<AddBankCardStore>(
      create: (context) => AddBankCardStore(),
      builder: (context, child) => AddBankCardBody(
        onCardAdded: onCardAdded,
        amount: amount,
        currency: currency,
        isPreview: isPreview,
      ),
    );
  }
}

class AddBankCardBody extends StatelessObserverWidget {
  const AddBankCardBody({
    Key? key,
    required this.onCardAdded,
    required this.amount,
    this.currency,
    required this.isPreview,
  }) : super(key: key);

  final Function() onCardAdded;
  final String amount;
  final CurrencyModel? currency;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final colors = sKit.colors;
    final store = AddBankCardStore.of(context);

    icon = store.saveCard
        ? const SCheckboxSelectedIcon()
        : const SCheckboxIcon();

    return SPageFrame(
      loaderText: intl.addCircleCard_pleaseWait,
      loading: store.loader,
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.addCircleCard_bigHeaderTitle,
        ),
      ),
      child: Column(
        children: [
          ScrollingFrame(
            children: [
              SFieldDividerFrame(
                child: SStandardField(
                  labelText: intl.addCircleCard_cardNumber,
                  keyboardType: TextInputType.number,
                  isError: store.cardNumberError,
                  disableErrorOnChanged: false,
                  // In formatting \u2005 is used instead of \u0020
                  // to avoid \u0020 input from the user
                  inputFormatters: [
                    MaskedTextInputFormatter(
                      mask: 'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
                      separator: '\u{2005}',
                    ),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9\u2005]'),
                    ),
                  ],
                  controller: store.cardNumberController,
                  onChanged: store.updateCardNumber,
                  suffixIcons: [
                    SIconButton(
                      onTap: () => store.pasteCode(),
                      defaultIcon: const SPasteIcon(),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.addCircleCard_expiryMonth,
                        keyboardType: TextInputType.number,
                        isError: store.expiryMonthError,
                        enableInteractiveSelection: false,
                        disableErrorOnChanged: false,
                        controller: store.expiryMonthController,
                        onChanged: store.updateExpiryMonth,
                      ),
                    ),
                  ),
                  const SDivider(
                    width: 1.0,
                    height: 88.0,
                  ),
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.addCircleCard_expiryYear,
                        keyboardType: TextInputType.number,
                        isError: store.expiryYearError,
                        enableInteractiveSelection: false,
                        disableErrorOnChanged: false,
                        controller: store.expiryYearController,
                        onChanged: store.updateExpiryYear,
                      ),
                    ),
                  ),
                ],
              ),
              Material(
                color: colors.white,
                child: SPaddingH24(
                  child: SStandardField(
                    labelText: intl.addCircleCard_cardholderName,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: store.updateCardholderName,
                    controller: store.cardholderNameController,
                    hideSpace: true,
                  ),
                ),
              ),
              if (isPreview) ...[
                const SpaceH20(),
                SPaddingH24(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SIconButton(
                            onTap: () {
                              store.checkSetter();
                            },
                            defaultIcon: icon,
                            pressedIcon: icon,
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
              const Spacer(),
              ContinueButtonFrame(
                child: SPrimaryButton2(
                  active: store.isCardDetailsValid,
                  name: intl.addCircleCard_continue,
                  onTap: () async {
                    sAnalytics.paymentDetailsContinue(source: 'Unlimint');
                    await store.addCard(
                      onSuccess: onCardAdded,
                      onError: () {},
                      isPreview: isPreview,
                      amount: amount,
                      currency: currency,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
