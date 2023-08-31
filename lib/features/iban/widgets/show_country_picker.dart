import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../auth/user_data/ui/widgets/country/country_item/country_profile_item.dart';
import '../../auth/user_data/ui/widgets/country/model/kyc_profile_country_model.dart';
import '../store/iban_store.dart';

void showCountryPicker(
  BuildContext context,
  ObservableList<KycProfileCountryModel> sortedCountries,
  String countryNameSearch,
  Function(KycProfileCountryModel) pickCountryFromSearch,
  Function(String) updateCountryNameSearch,
  IbanStoreBase store,
) {

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      _Countries(
        sortedCountries: sortedCountries,
        countryNameSearch: countryNameSearch,
        pickCountryFromSearch: pickCountryFromSearch,
        store: store,
      ),
      const SpaceH24(),
    ],
  );
}

class _Countries extends StatefulObserverWidget {
  const _Countries({
    Key? key,
    required this.sortedCountries,
    required this.countryNameSearch,
    required this.pickCountryFromSearch,
    required this.store,
  }) : super(key: key);

  final ObservableList<KycProfileCountryModel> sortedCountries;
  final String countryNameSearch;
  final Function(KycProfileCountryModel) pickCountryFromSearch;
  final IbanStoreBase store;

  @override
  State<_Countries> createState() => _CountryState();
}

class _CountryState extends State<_Countries> {
  late String searchCountry;
  List<KycProfileCountryModel> filteredCountries = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCountry = '';
    filteredCountries = widget.store.sortedCountries;
  }

  void changeSearchCountry (String value) {
    setState(() {
      searchCountry = value;
      filteredCountries = widget.store.sortedCountries.where(
            (element) => element.countryName.toLowerCase().contains(
          searchCountry.toLowerCase(),
        ),
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 145,
            ),
            Observer(
              builder: (context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      for (final country in filteredCountries) ...[
                        CountryProfileItem(
                          onTap: () {
                            if (country.isBlocked) {
                              sNotification.showError(
                                intl.user_data_bottom_sheet_country,
                                id: 1,
                              );
                            } else {
                              widget.store.pickCountryFromSearch(country);
                              widget.pickCountryFromSearch(country);
                              sRouter.pop();
                            }
                          },
                          countryCode: country.countryCode,
                          countryName: country.countryName,
                          isBlocked: country.isBlocked,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        Positioned(
          child: SPaddingH24(
            child: Container(
              height: 145,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH20(),
                  Text(
                    intl.kycCountry_countryOfIssue,
                    style: sTextH4Style,
                  ),
                  SStandardField(
                    autofocus: true,
                    labelText: intl.showKycCountryPicker_search,
                    controller: searchController,
                    onChanged: (value) {
                      changeSearchCountry(value);
                    },
                  ),
                  const SDivider(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
