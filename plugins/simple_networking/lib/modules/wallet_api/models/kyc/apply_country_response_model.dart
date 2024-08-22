import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_country_response_model.freezed.dart';
part 'apply_country_response_model.g.dart';

@freezed
class ApplyCountryResponseModel with _$ApplyCountryResponseModel {
  const factory ApplyCountryResponseModel({
    @Default('') String url,
  }) = _ApplyCountryResponseModel;

  factory ApplyCountryResponseModel.fromJson(Map<String, dynamic> json) => _$ApplyCountryResponseModelFromJson(json);
}
