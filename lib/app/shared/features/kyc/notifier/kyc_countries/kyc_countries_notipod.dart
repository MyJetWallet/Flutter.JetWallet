import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../providers/kyc_countries_pod/kyc_countries_spod.dart';
import '../../model/kyc_country_model.dart';
import '../../model/kyc_operation_status_model.dart';
import 'kyc_countries_notifier.dart';

final kycCountriesNotipod = StateNotifierProvider.autoDispose<
    KycCountriesNotifier, KycCountriesState>((ref) {
  final kycCountries = ref.watch(kycCountriesSpod);
  final userInfo = ref.read(userInfoNotipod);
  final value = <KycCountryModel>[];

  kycCountries.whenData((data) {
    if (data.countries.isNotEmpty) {
      for (var i = 0; i < data.countries.length; i++) {
        final documents = <KycDocumentType>[];
        if (data.countries[i].acceptedDocuments.isNotEmpty) {
          for (final document in data.countries[i].acceptedDocuments) {
            documents.add(kycDocumentType(document));
          }
        }

        value.add(
          KycCountryModel(
            countryCode: data.countries[i].countryCode,
            countryName: data.countries[i].countryName,
            acceptedDocuments: documents,
            isBlocked: data.countries[i].isBlocked,
          ),
        );
      }
    }
  });

  return KycCountriesNotifier(
    read: ref.read,
    countries: KycCountriesState(countries: value),
    countryOfRegistration: userInfo.countryOfRegistration,
  );
});
