import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_gift_by_phone_request_model.freezed.dart';
part 'send_gift_by_phone_request_model.g.dart';

@freezed
class SendGiftByPhoneRequestModel with _$SendGiftByPhoneRequestModel {
  factory SendGiftByPhoneRequestModel({
    String? requestId,
    String? assetSymbol,
    @DecimalSerialiser() required Decimal amount,
    String? lang,
    String? toPhoneCode,
    String? phoneNumber,
    String? toPhoneBody,
    String? toPhoneIso,
    String? pin,
  }) = _SendGiftByPhoneRequestModel;

  factory SendGiftByPhoneRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendGiftByPhoneRequestModelFromJson(json);
}
