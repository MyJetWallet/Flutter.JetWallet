import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/store/add_circle_card_store.dart';
import 'package:jetwallet/features/add_circle_card/ui/circle_billing_address/widgets/country_selector_button.dart';
import 'package:jetwallet/features/add_circle_card/ui/circle_billing_address/widgets/show_country_selector.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/circle_progress_indicator.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage(name: 'CircleBillingAddressRouter')
class CircleBillingAddress extends StatelessWidget {
  const CircleBillingAddress({
    super.key,
    required this.onCardAdded,
    required this.expiryDate,
    required this.cardholderName,
    required this.cardNumber,
    required this.cvv,
  });

  final Function(CircleCard) onCardAdded;
  final String expiryDate;
  final String cardholderName;
  final String cardNumber;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    return Provider<AddCircleCardStore>(
      create: (context) => AddCircleCardStore(),
      builder: (context, child) => CircleBillingAddressBody(
        onCardAdded: onCardAdded,
        expiryDate: expiryDate,
        cvv: cvv,
        cardholderName: cardholderName,
        cardNumber: cardNumber,
      ),
    );
  }
}

class CircleBillingAddressBody extends StatelessObserverWidget {
  const CircleBillingAddressBody({
    super.key,
    required this.onCardAdded,
    required this.expiryDate,
    required this.cardholderName,
    required this.cardNumber,
    required this.cvv,
  });

  final Function(CircleCard) onCardAdded;
  final String expiryDate;
  final String cardholderName;
  final String cardNumber;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    final store = AddCircleCardStore.of(context);

    store.updateCardNumber(cardNumber);
    store.updateCardholderName(cardholderName);
    store.updateCvv(cvv);
    store.updateExpiryDate(expiryDate);
    final navigationAllowed = (store.loader?.loading ?? true) || store.billingAddressEnableButton;

    return SPageFrame(
      loaderText: intl.circleBillingAddress_pleaseWait,
      loading: store.loader,
      header: SPaddingH24(
        child: SBigHeader(
          onBackButtonTap: () {
            if (navigationAllowed) {
              Navigator.pop(context);
            }
          },
          title: intl.circleBillingAddress_billingAddress,
        ),
      ),
      child: Column(
        children: [
          const CircleProgressIndicator(),
          ScrollingFrame(
            children: [
              SFieldDividerFrame(
                child: SStandardField(
                  controller: store.streetAddress1Controller,
                  labelText: intl.circleBillingAddress_streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: store.updateAddress1,
                  hideSpace: true,
                ),
              ),
              SFieldDividerFrame(
                child: SStandardField(
                  controller: store.streetAddress2Controller,
                  labelText: '${intl.circleBillingAddress_streetAddress} 2'
                      ' (${intl.circleBillingAddress_optional})',
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: store.updateAddress2,
                  hideSpace: true,
                ),
              ),
              SFieldDividerFrame(
                child: SStandardField(
                  controller: store.cityController,
                  labelText: intl.circleBillingAddress_city,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: store.updateCity,
                  hideSpace: true,
                ),
              ),
              SFieldDividerFrame(
                child: SStandardField(
                  controller: store.districtController,
                  labelText: intl.circleBillingAddress_district,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: store.updateDistrict,
                  hideSpace: true,
                ),
              ),
              SFieldDividerFrame(
                child: SStandardField(
                  controller: store.postalCodeController,
                  labelText: intl.circleBillingAddress_postalCode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: store.updatePostalCode,
                  hideSpace: true,
                ),
              ),
              CountrySelectorButton(
                country: store.selectedCountry!,
                onTap: () => showCountrySelector(context),
              ),
              const Spacer(),
              ContinueButtonFrame(
                child: SButton.blue(
                  text: intl.circleBillingAddress_continue,
                  callback: navigationAllowed && store.isBillingAddressValid
                      ? () async {
                          store.billingAddressEnableButton = false;
                          await store.addCard(
                            onSuccess: onCardAdded,
                            onError: () {
                              sRouter.maybePop();
                              store.clearBillingDetails();
                              store.billingAddressEnableButton = true;
                            },
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
