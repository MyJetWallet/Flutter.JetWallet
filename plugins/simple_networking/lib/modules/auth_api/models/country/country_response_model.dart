import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_response_model.freezed.dart';
part 'country_response_model.g.dart';

@freezed
class CountryResponseModel with _$CountryResponseModel {
  const factory CountryResponseModel({
    required String countryCode,
  }) = _CountryResponseModel;

  factory CountryResponseModel.fromJson(Map<String, dynamic> json) => _$CountryResponseModelFromJson(json);
}
