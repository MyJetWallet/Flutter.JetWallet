import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/continue_button_frame.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../auth/user_data/ui/widgets/country/model/kyc_profile_country_model.dart';
import '../store/iban_store.dart';
import 'country_picker.dart';

@RoutePage(name: 'IbanAddressRouter')
class IbanBillingAddress extends StatelessObserverWidget {
  const IbanBillingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<IbanStore>();
    final colors = sKit.colors;
    final focusNode = FocusNode();

    final navigationAllowed =
        (store.loader?.loading ?? true) || store.billingAddressEnableButton;

    return SPageFrame(
      loaderText: intl.circleBillingAddress_pleaseWait,
      loading: store.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          onBackButtonTap: () {
            if (navigationAllowed) {
              Navigator.pop(context);
            }
          },
          title: intl.iban_address,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: Form(
                key: store.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH16(),
                    SPaddingH24(
                      child: Text(
                        intl.iban_address_description,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey2,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SpaceH16(),
                    SFieldDividerFrame(
                      child: CountryAccountField(
                        store: store,
                        activeCountry: store.activeCountry,
                        sortedCountries: store.sortedCountries,
                        countryNameSearch: store.countryNameSearch,
                        pickCountryFromSearch:
                            (KycProfileCountryModel country) {
                          focusNode.requestFocus();
                        },
                        updateCountryNameSearch: store.updateCountryNameSearch,
                        initCountrySearch: store.initCountrySearch,
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        focusNode: focusNode,
                        controller: store.streetAddress1Controller,
                        labelText: intl.iban_address,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: store.updateAddress1,
                        isError: store.streetAddress1Error,
                        hideSpace: true,
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        controller: store.streetAddress2Controller,
                        labelText: '${intl.iban_address} 2'
                            ' (${intl.circleBillingAddress_optional})',
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: store.updateAddress2,
                        isError: store.streetAddress2Error,
                        hideSpace: true,
                      ),
                    ),
                    Text(
                      '${store.streetAddress1} ${store.streetAddress2} '
                      '${store.city} ${store.postalCode}'
                      '${store.activeCountry?.countryName}',
                      style: sSubtitle3Style.copyWith(
                        color: Colors.transparent,
                        height: 0,
                        fontSize: 0,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.59,
                          child: SFieldDividerFrame(
                            child: SStandardField(
                              controller: store.cityController,
                              labelText: intl.circleBillingAddress_city,
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: store.updateCity,
                              isError: store.cityError,
                              hideSpace: true,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 88,
                          color: colors.grey4,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: SFieldDividerFrame(
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
                        ),
                      ],
                    ),
                    const Spacer(),
                    ContinueButtonFrame(
                      child: SPrimaryButton4(
                        active: navigationAllowed &&
                            store.isBillingAddressValid &&
                            !store.streetAddress1Error &&
                            !store.streetAddress1Error &&
                            !store.cityError,
                        name: intl.circleBillingAddress_continue,
                        onTap: () async {
                          store.billingAddressEnableButton = false;
                          await store.saveAddress(onError: () {});
                        },
                      ),
                    ),
                    const SpaceH42(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
