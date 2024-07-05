import 'package:freezed_annotation/freezed_annotation.dart';

part 'wire_countries_response_model.freezed.dart';
part 'wire_countries_response_model.g.dart';

@freezed
class WireCountriesResponseModel with _$WireCountriesResponseModel {
  const factory WireCountriesResponseModel({
    @JsonKey(name: 'supportedCountries') required List<CircleCountry> countries,
  }) = _WireCountriesResponseModel;

  factory WireCountriesResponseModel.fromJson(Map<String, dynamic> json) => _$WireCountriesResponseModelFromJson(json);
}

@freezed
class CircleCountry with _$CircleCountry {
  const factory CircleCountry({
    required String countryName,
    required String alpha2Code,
    required String alpha3Code,
    required int numeric,
    required BankAccountType bankAccountType,
  }) = _CircleCountry;

  factory CircleCountry.fromJson(Map<String, dynamic> json) => _$CircleCountryFromJson(json);
}

enum BankAccountType {
  @JsonValue(0)
  us,
  @JsonValue(1)
  sepa,
  @JsonValue(2)
  swift,
}
