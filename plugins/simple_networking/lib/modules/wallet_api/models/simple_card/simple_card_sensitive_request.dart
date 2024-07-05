import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_sensitive_request.freezed.dart';
part 'simple_card_sensitive_request.g.dart';

@freezed
class SimpleCardSensitiveRequest with _$SimpleCardSensitiveRequest {
  factory SimpleCardSensitiveRequest({
    required String cardId,
    required String publicKey,
    required String pin,
    required String timeStamp,
  }) = _SimpleCardSensitiveRequest;

  factory SimpleCardSensitiveRequest.fromJson(Map<String, dynamic> json) => _$SimpleCardSensitiveRequestFromJson(json);
}
