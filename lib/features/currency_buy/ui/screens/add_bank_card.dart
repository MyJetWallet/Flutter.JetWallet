import 'dart:async';

import 'package:auto_route/auto_route.dart';
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

import '../../../../core/di/di.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/device_size/device_size.dart';
import '../../../kyc/kyc_service.dart';
import '../../../kyc/models/kyc_operation_status_model.dart';

@RoutePage(name: 'AddUnlimintCardRouter')
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
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;
    final store = AddBankCardStore.of(context);
    final kycState = getIt.get<KycService>();
    final status = kycOperationStatus(KycStatus.kycRequired);

    final isUserVerified = kycState.depositStatus != status &&
        kycState.sellStatus != status &&
        kycState.withdrawalStatus != status;
    icon =
        store.saveCard ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    var heightOfSpace = MediaQuery.of(context).size.height - 402;
    if (!isUserVerified) {
      heightOfSpace -= heightOfSpace;
    }
    if (isPreview) {
      heightOfSpace -= 24;
    }

    return SPageFrame(
      color: colors.grey5,
      loading: store.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.addCircleCard_bigHeaderTitle,
          showBackButton: false,
          onCLoseButton: () {
            sRouter.pop();
          },
          showCloseButton: true,
        ),
      ),
      child: deviceSize.when(
        small: () {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Observer(
                  builder: (context) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
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
                                    mask:
                                        'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
                                    separator: '\u{2005}',
                                  ),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9\u2005]'),
                                  ),
                                ],
                                focusNode: store.cardNode,
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
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      if (!hasFocus) {
                                        store.yearFieldTap();
                                      }
                                    },
                                    child: SFieldDividerFrame(
                                      child: SStandardField(
                                        labelText:
                                            intl.addCircleCard_expiryMonth,
                                        maxLength: 2,
                                        focusNode: store.monthNode,
                                        keyboardType: TextInputType.number,
                                        isError: store.expiryMonthError,
                                        enableInteractiveSelection: false,
                                        disableErrorOnChanged: false,
                                        controller: store.expiryMonthController,
                                        onChanged: store.updateExpiryMonth,
                                      ),
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
                                      maxLength: 4,
                                      focusNode: store.yearNode,
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
                            if (!isUserVerified)
                              Material(
                                color: colors.white,
                                child: SPaddingH24(
                                  child: SStandardField(
                                    labelText:
                                        intl.addCircleCard_cardholderName,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onChanged: store.updateCardholderName,
                                    controller: store.cardholderNameController,
                                    hideSpace: true,
                                  ),
                                ),
                              ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              color: colors.grey5,
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
                                                defaultIcon: icon,
                                                pressedIcon: icon,
                                              ),
                                            ],
                                          ),
                                          const SpaceW10(),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                82,
                                            child: SPolicyText(
                                              firstText:
                                                  intl.addCircleCard_saveCard,
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
                                          store.toggleClick(false);
                                          Timer(
                                            const Duration(
                                              seconds: 2,
                                            ),
                                            () => store.toggleClick(true),
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
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        medium: () {
          return Column(
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
                  focusNode: store.cardNode,
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
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          store.yearFieldTap();
                        }
                      },
                      child: SFieldDividerFrame(
                        child: SStandardField(
                          labelText: intl.addCircleCard_expiryMonth,
                          maxLength: 2,
                          focusNode: store.monthNode,
                          keyboardType: TextInputType.number,
                          isError: store.expiryMonthError,
                          enableInteractiveSelection: false,
                          disableErrorOnChanged: false,
                          controller: store.expiryMonthController,
                          onChanged: store.updateExpiryMonth,
                        ),
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
                        maxLength: 4,
                        focusNode: store.yearNode,
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
              if (!isUserVerified)
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
              const Spacer(),
              Container(
                color: colors.grey5,
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
                                    sAnalytics.newBuyTapSaveCard();
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
                    ContinueButtonFrame(
                      child: SPrimaryButton2(
                        active: store.isCardDetailsValid,
                        name: intl.addCircleCard_continue,
                        onTap: () async {
                          if (store.canClick) {
                            store.toggleClick(false);
                            Timer(
                              const Duration(
                                seconds: 2,
                              ),
                              () => store.toggleClick(true),
                            );
                          } else {
                            return;
                          }
                          sAnalytics.newBuyTapCardContinue(
                            saveCard: '${store.saveCard}',
                          );
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
              ),
            ],
          );
        },
      ),
    );
  }
}
