import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'simple_card_create_request.freezed.dart';
part 'simple_card_create_request.g.dart';

@freezed
class SimpleCardCreateRequest with _$SimpleCardCreateRequest {
  factory SimpleCardCreateRequest({
    required String requestId,
    required String pin,
  }) = _SimpleCardCreateRequest;

  factory SimpleCardCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardCreateRequestFromJson(json);
}
