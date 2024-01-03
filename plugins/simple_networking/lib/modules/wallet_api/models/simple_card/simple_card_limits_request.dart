import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_limits_request.freezed.dart';
part 'simple_card_limits_request.g.dart';

@freezed
class SimpleCardLimitsRequestModel with _$SimpleCardLimitsRequestModel {
  factory SimpleCardLimitsRequestModel({
    required String cardId,
  }) = _SimpleCardLimitsRequestModel;

  factory SimpleCardLimitsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardLimitsRequestModelFromJson(json);
}
