import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_add_request_model.freezed.dart';
part 'card_add_request_model.g.dart';

@freezed
class CardAddRequestModel with _$CardAddRequestModel {
  const factory CardAddRequestModel({
    required String encKeyId,
    required String requestGuid,
    required String encData,
    required int expMonth,
    required int expYear,
    required bool isActive,
    final String? cardLabel,
    final String? cardAssetSymbol,
  }) = _CardAddRequestModel;

  factory CardAddRequestModel.fromJson(Map<String, dynamic> json) => _$CardAddRequestModelFromJson(json);
}
