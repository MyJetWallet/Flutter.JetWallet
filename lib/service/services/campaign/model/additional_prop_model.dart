import 'package:freezed_annotation/freezed_annotation.dart';

part 'additional_prop_model.freezed.dart';
part 'additional_prop_model.g.dart';

@freezed
class AdditionalPropModel with _$AdditionalPropModel {
  const factory AdditionalPropModel({
    @JsonKey(name: 'Passed') String? passed,
    @JsonKey(name: 'Asset') String? asset,
    @JsonKey(name: 'RequiredAmount') String? requiredAmount,
    @JsonKey(name: 'TradedAmount') String? tradedAmount,
  }) = _AdditionalPropModel;

  factory AdditionalPropModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionalPropModelFromJson(json);
}
