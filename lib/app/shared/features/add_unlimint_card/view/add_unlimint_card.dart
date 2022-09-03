import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../models/currency_model.dart';
import '../../add_circle_card/helper/masked_text_input_formatter.dart';
import '../../add_circle_card/view/components/continue_button_frame.dart';
import '../notifier/add_unlimint_card_notipod.dart';
import 'components/scrolling_frame.dart';

class AddUnlimintCard extends HookWidget {
  const AddUnlimintCard({
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

  static void push({
    required BuildContext context,
    required Function() onCardAdded,
    required String amount,
    CurrencyModel? currency,
    bool isPreview = false,
  }) {
    navigatorPush(
      context,
      AddUnlimintCard(
        onCardAdded: onCardAdded,
        amount: amount,
        currency: currency,
        isPreview: isPreview,
      ),
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required Function() onCardAdded,
    required String amount,
    required CurrencyModel currency,
    bool isPreview = false,
  }) {
    navigatorPushReplacement(
      context,
      AddUnlimintCard(
        onCardAdded: onCardAdded,
        amount: amount,
        currency: currency,
        isPreview: isPreview,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final intl = context.read(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(addUnlimintCardNotipod);
    final notifier = useProvider(addUnlimintCardNotipod.notifier);
    final bankCardService = useProvider(cardBuyServicePod);

    if (state.saveCard) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return SPageFrame(
      loaderText: intl.addCircleCard_pleaseWait,
      loading: state.loader,
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
                  errorNotifier: state.cardNumberError,
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
                  onChanged: notifier.updateCardNumber,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.addCircleCard_expiryMonth,
                        keyboardType: TextInputType.number,
                        errorNotifier: state.expiryMonthError,
                        enableInteractiveSelection: false,
                        disableErrorOnChanged: false,
                        onChanged: notifier.updateExpiryMonth,
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
                        errorNotifier: state.expiryYearError,
                        enableInteractiveSelection: false,
                        disableErrorOnChanged: false,
                        onChanged: notifier.updateExpiryYear,
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
                    onChanged: notifier.updateCardholderName,
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
                              notifier.checkSetter();
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
                  active: state.isCardDetailsValid,
                  name: intl.addCircleCard_continue,
                  onTap: () async {
                    final response = await bankCardService.encryptionKey(
                      intl.localeName,
                    );
                    final encKeyId = response.keyId;
                    final encKey = response.key;

                    final cardNumber = state.cardNumber
                        .replaceAll('\u{2005}', '');
                    if (isPreview) {
                      if (state.saveCard) {
                        await notifier.addCard(
                          onSuccess: onCardAdded,
                          onError: () {},
                        );
                      }
                      notifier.showPreview(
                        context: context,
                        cardNumber: cardNumber,
                        currency: currency!,
                        encKey: encKey,
                        encKeyId: encKeyId,
                        amount: amount,
                      );
                    } else {
                      await notifier.addCard(
                        onSuccess: onCardAdded,
                        onError: () {},
                      );
                    }
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
