import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/add_circle_card/store/add_circle_card_store.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/circle_progress_indicator.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage(name: 'AddCircleCardRouter')
class AddCircleCard extends StatelessWidget {
  const AddCircleCard({
    Key? key,
    required this.onCardAdded,
  }) : super(key: key);

  final Function(CircleCard) onCardAdded;

  @override
  Widget build(BuildContext context) {
    return Provider<AddCircleCardStore>(
      create: (context) => AddCircleCardStore(),
      builder: (context, child) => AddCircleCardBody(
        onCardAdded: onCardAdded,
      ),
    );
  }
}

class AddCircleCardBody extends StatelessObserverWidget {
  const AddCircleCardBody({
    Key? key,
    required this.onCardAdded,
  }) : super(key: key);

  final Function(CircleCard) onCardAdded;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final store = AddCircleCardStore.of(context);

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
          Row(
            children: const [
              Expanded(
                child: CircleProgressIndicator(),
              ),
              Spacer(),
            ],
          ),
          ScrollingFrame(
            children: [
              SFieldDividerFrame(
                child: SStandardField(
                  labelText: intl.addCircleCard_cardNumber,
                  keyboardType: TextInputType.number,
                  isError: store.cardNumberError,
                  disableErrorOnChanged: false,
                  controller: store.cardNumberController,
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
                  onChanged: store.updateCardNumber,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardField(
                        controller: store.expiryDateController,
                        labelText: intl.addCircleCard_expiryDate,
                        keyboardType: TextInputType.number,
                        isError: store.expiryDateError,
                        enableInteractiveSelection: false,
                        disableErrorOnChanged: false,
                        inputFormatters: [
                          MaskedTextInputFormatter(
                            mask: 'xx/xx',
                            separator: '/',
                          ),
                        ],
                        onChanged: store.updateExpiryDate,
                      ),
                    ),
                  ),
                  const SDivider(
                    width: 1.0,
                    height: 88.0,
                  ),
                  Expanded(
                    child: SFieldDividerFrame(
                      child: SStandardFieldObscure(
                        controller: store.cvvController,
                        labelText: 'CVV',
                        keyboardType: TextInputType.number,
                        isError: store.cvvError,
                        inputFormatters: [
                          MaskedTextInputFormatter(
                            mask: 'xxx',
                            separator: '',
                          ),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: store.updateCvv,
                      ),
                    ),
                  ),
                ],
              ),
              Material(
                color: colors.white,
                child: SPaddingH24(
                  child: SStandardField(
                    controller: store.cardholderNameController,
                    labelText: intl.addCircleCard_cardholderName,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: store.updateCardholderName,
                    hideSpace: true,
                  ),
                ),
              ),
              const Spacer(),
              ContinueButtonFrame(
                child: SPrimaryButton2(
                  active: store.isCardDetailsValid,
                  name: intl.addCircleCard_continue,
                  onTap: () async {
                    await sRouter.push(
                      CircleBillingAddressRouter(
                        onCardAdded: onCardAdded,
                        expiryDate: store.expiryDate,
                        cvv: store.cvv,
                        cardholderName: store.cardholderName,
                        cardNumber: store.cardNumber,
                      ),
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
