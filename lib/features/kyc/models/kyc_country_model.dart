import 'package:freezed_annotation/freezed_annotation.dart';

import 'kyc_operation_status_model.dart';

part 'kyc_country_model.freezed.dart';
part 'kyc_country_model.g.dart';

@freezed
class KycCountriesState with _$KycCountriesState {
  const factory KycCountriesState({
    @Default([]) List<KycCountryModel> countries,
    @Default([]) List<KycCountryModel> sortedCountries,
    @Default('') String countryNameSearch,
    KycCountryModel? activeCountry,
  }) = _KycCountriesState;
}

@freezed
class KycCountryModel with _$KycCountryModel {
  const factory KycCountryModel({
    @Default(false) bool isBlocked,
    @Default([]) List<KycDocumentType> acceptedDocuments,
    required String countryCode,
    required String countryName,
  }) = _KycCountryModel;

  factory KycCountryModel.fromJson(Map<String, dynamic> json) => _$KycCountryModelFromJson(json);
}
