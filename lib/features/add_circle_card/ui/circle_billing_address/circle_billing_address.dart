import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/add_circle_card/store/add_circle_card_store.dart';
import 'package:jetwallet/features/add_circle_card/ui/circle_billing_address/widgets/country_selector_button.dart';
import 'package:jetwallet/features/add_circle_card/ui/circle_billing_address/widgets/show_country_selector.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/circle_progress_indicator.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

class CircleBillingAddress extends StatelessObserverWidget {
  const CircleBillingAddress({
    Key? key,
    required this.onCardAdded,
  }) : super(key: key);

  final Function(CircleCard) onCardAdded;

  @override
  Widget build(BuildContext context) {
    final store = AddCircleCardStore.of(context);

    final navigationAllowed =
        (store.loader?.loading ?? true) || store.billingAddressEnableButton;

    return WillPopScope(
      onWillPop: () => Future.value(navigationAllowed),
      child: SPageFrame(
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
                    initialValue: store.streetAddress1,
                    labelText: intl.circleBillingAddress_streetAddress,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: store.updateAddress1,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: store.streetAddress2,
                    labelText: '${intl.circleBillingAddress_streetAddress} 2'
                        ' (${intl.circleBillingAddress_optional})',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: store.updateAddress2,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: store.city,
                    labelText: intl.circleBillingAddress_city,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: store.updateCity,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: store.district,
                    labelText: intl.circleBillingAddress_district,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: store.updateDistrict,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: store.postalCode,
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
                  child: SPrimaryButton2(
                    active: navigationAllowed && store.isBillingAddressValid,
                    name: intl.circleBillingAddress_continue,
                    onTap: () async {
                      sAnalytics.circleContinueAddress();
                      store.billingAddressEnableButton = false;
                      await store.addCard(
                        onSuccess: onCardAdded,
                        onError: () {
                          Navigator.pop(context);
                          store.clearBillingDetails();
                          store.billingAddressEnableButton = true;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
