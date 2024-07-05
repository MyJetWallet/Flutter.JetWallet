import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_create_request.freezed.dart';
part 'simple_card_create_request.g.dart';

@freezed
class SimpleCardCreateRequest with _$SimpleCardCreateRequest {
  factory SimpleCardCreateRequest({
    required String requestId,
    required String pin,
    required String password,
  }) = _SimpleCardCreateRequest;

  factory SimpleCardCreateRequest.fromJson(Map<String, dynamic> json) => _$SimpleCardCreateRequestFromJson(json);
}
