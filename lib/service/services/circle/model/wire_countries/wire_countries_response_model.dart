import 'package:freezed_annotation/freezed_annotation.dart';

part 'wire_countries_response_model.freezed.dart';
part 'wire_countries_response_model.g.dart';

@freezed
class WireCountriesResponseModel with _$WireCountriesResponseModel {
  const factory WireCountriesResponseModel({
    required String name,
  }) = _WireCountriesResponseModel;

  factory WireCountriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WireCountriesResponseModelFromJson(json);
}
