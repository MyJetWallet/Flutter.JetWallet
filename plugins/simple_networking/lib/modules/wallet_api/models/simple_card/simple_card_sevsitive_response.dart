import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_sevsitive_response.freezed.dart';
part 'simple_card_sevsitive_response.g.dart';

@freezed
class SimpleCardSensitiveResponse with _$SimpleCardSensitiveResponse {
  factory SimpleCardSensitiveResponse({
    final String? cardNumber,
    final String? cardHolderName,
    final String? cardExpDate,
    final String? cardCvv,
  }) = _SimpleCardSensitiveResponse;

  factory SimpleCardSensitiveResponse.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardSensitiveResponseFromJson(json);
}

@freezed
class SimpleCardSensitiveWithId with _$SimpleCardSensitiveWithId {
  factory SimpleCardSensitiveWithId({
    final String? cardNumber,
    final String? cardHolderName,
    final String? cardExpDate,
    final String? cardCvv,
    required String cardId,
  }) = _SimpleCardSensitiveWithId;

  factory SimpleCardSensitiveWithId.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardSensitiveWithIdFromJson(json);
}
