import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_set_password_request.freezed.dart';
part 'simple_card_set_password_request.g.dart';

@freezed
class SimpleCardSetPasswordRequest with _$SimpleCardSetPasswordRequest {
  factory SimpleCardSetPasswordRequest({
    required String cardId,
    required String password,
  }) = _SimpleCardSetPasswordRequest;

  factory SimpleCardSetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardSetPasswordRequestFromJson(json);
}
