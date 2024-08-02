import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/iban/widgets/show_country_picker.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../auth/user_data/ui/widgets/country/model/kyc_profile_country_model.dart';
import '../store/iban_store.dart';

class CountryAccountField extends StatefulObserverWidget {
  const CountryAccountField({
    this.activeCountry,
    required this.store,
    required this.initCountrySearch,
    required this.sortedCountries,
    required this.updateCountryNameSearch,
    required this.countryNameSearch,
    required this.pickCountryFromSearch,
  });

  final KycProfileCountryModel? activeCountry;
  final Function() initCountrySearch;
  final Function(String) updateCountryNameSearch;
  final ObservableList<KycProfileCountryModel> sortedCountries;
  final String countryNameSearch;
  final Function(KycProfileCountryModel) pickCountryFromSearch;
  final IbanStoreBase store;

  @override
  State<CountryAccountField> createState() => _CountryAccountFieldState();
}

class _CountryAccountFieldState extends State<CountryAccountField> {
  late KycProfileCountryModel? activeCountry;

  @override
  void initState() {
    super.initState();
    activeCountry = widget.activeCountry;
  }

  void changeCountry(KycProfileCountryModel newCountry) {
    widget.pickCountryFromSearch(newCountry);
    activeCountry = newCountry;
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.white,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          widget.initCountrySearch();
          showCountryPicker(
            context,
            widget.sortedCountries,
            widget.countryNameSearch,
            changeCountry,
            widget.updateCountryNameSearch,
            widget.store,
          );
        },
        child: AbsorbPointer(
          child: Stack(
            children: [
              if (activeCountry != null)
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      FlagItem(
                        countryCode: activeCountry!.countryCode,
                      ),
                      const SpaceW10(),
                      Text(
                        activeCountry!.countryName,
                        style: sSubtitle2Style.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              SStandardField(
                hideClearButton: true,
                readOnly: true,
                controller: TextEditingController()..text = activeCountry != null ? ' ' : '',
                labelText: intl.user_data_country,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
