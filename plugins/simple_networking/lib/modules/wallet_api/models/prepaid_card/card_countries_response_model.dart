import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_countries_response_model.freezed.dart';
part 'card_countries_response_model.g.dart';

@freezed
class CardCountriesResponseModel with _$CardCountriesResponseModel {
  const factory CardCountriesResponseModel({
    required String clientCountry,
    @Default([]) List<String> countries,
  }) = _CardCountriesResponseModel;

  factory CardCountriesResponseModel.fromJson(Map<String, dynamic> json) => _$CardCountriesResponseModelFromJson(json);
}
