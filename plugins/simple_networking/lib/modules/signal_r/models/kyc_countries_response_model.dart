import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_countries_response_model.freezed.dart';
part 'kyc_countries_response_model.g.dart';

@freezed
class KycCountriesResponseModel with _$KycCountriesResponseModel {
  const factory KycCountriesResponseModel({
    @Default([]) List<KycCountryResponseModel> countries,
  }) = _KycCountriesResponseModel;

  factory KycCountriesResponseModel.fromJson(Map<String, dynamic> json) => _$KycCountriesResponseModelFromJson(json);
}

@freezed
class KycCountryResponseModel with _$KycCountryResponseModel {
  const factory KycCountryResponseModel({
    @Default(false) bool isBlocked,
    @Default([]) List<int> acceptedDocuments,
    required String countryCode,
    required String countryName,
  }) = _KycCountryResponseModel;

  factory KycCountryResponseModel.fromJson(Map<String, dynamic> json) => _$KycCountryResponseModelFromJson(json);
}
