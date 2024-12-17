import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_country_request_model.freezed.dart';
part 'apply_country_request_model.g.dart';

@freezed
class ApplyCountryRequestModel with _$ApplyCountryRequestModel {
  const factory ApplyCountryRequestModel({
    @Default('') String countryCode,
    @Default(false) bool isCardFlow,
  }) = _ApplyCountryRequestModel;

  factory ApplyCountryRequestModel.fromJson(Map<String, dynamic> json) => _$ApplyCountryRequestModelFromJson(json);
}
