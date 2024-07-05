import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_list_response_model.freezed.dart';
part 'country_list_response_model.g.dart';

@freezed
class CountryListResponseModel with _$CountryListResponseModel {
  const factory CountryListResponseModel({
    required List<Country> countries,
  }) = _CountryListResponseModel;

  factory CountryListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CountryListResponseModelFromJson(json);
}

@freezed
class Country with _$Country {
  factory Country({
    @Default('') String countryName,
    @Default('') String countryCode,
    @Default(false) bool isBlocked,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
}
