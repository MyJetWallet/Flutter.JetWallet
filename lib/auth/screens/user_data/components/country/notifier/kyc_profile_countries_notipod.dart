import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../app/shared/providers/kyc_profile_countries_pod/kyc_profile_countries_spod.dart';

import '../../../../../../app/shared/providers/profile_user_country_pod/kyc_profile_countries_spod.dart';
import '../model/kyc_profile_country_model.dart';
import 'kyc_profile_countries_notifier.dart';

final kycProfileCountriesNotipod = StateNotifierProvider.autoDispose<
    KycProfileCountriesNotifier, KycProfileCountriesState>((ref) {
  final kycCountries = ref.watch(kycProfileCountriesFpod);
  final value = <KycProfileCountryModel>[];
  ref.watch(profileUserCountryFpod);
  kycCountries.whenData((data) {
    if (data.countries.isNotEmpty) {
      for (var i = 0; i < data.countries.length; i++) {
        value.add(
          KycProfileCountryModel(
            countryCode: data.countries[i].countryCode,
            countryName: data.countries[i].countryName,
            isBlocked: data.countries[i].isBlocked,
          ),
        );
      }
    }
  });

  return KycProfileCountriesNotifier(
    read: ref.read,
    countries: KycProfileCountriesState(countries: value),
  );
});
