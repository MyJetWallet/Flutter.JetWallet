import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_remind_pin_response.freezed.dart';
part 'simple_card_remind_pin_response.g.dart';

@freezed
class SimpleCardRemindPinResponse with _$SimpleCardRemindPinResponse {
  factory SimpleCardRemindPinResponse({
    final String? phoneNumber,
  }) = _SimpleCardRemindPinResponse;

  factory SimpleCardRemindPinResponse.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardRemindPinResponseFromJson(json);
}
