import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_profile_country_model.freezed.dart';

@freezed
class KycProfileCountriesState with _$KycProfileCountriesState {
  const factory KycProfileCountriesState({
    @Default([]) List<KycProfileCountryModel> countries,
    @Default([]) List<KycProfileCountryModel> sortedCountries,
    @Default('') String countryNameSearch,
    KycProfileCountryModel? activeCountry,
  }) = _KycProfileCountriesState;
}

@freezed
class KycProfileCountryModel with _$KycProfileCountryModel {
  const factory KycProfileCountryModel({
    @Default(false) bool isBlocked,
    required String countryCode,
    required String countryName,
  }) = _KycProfileCountryModel;
}
