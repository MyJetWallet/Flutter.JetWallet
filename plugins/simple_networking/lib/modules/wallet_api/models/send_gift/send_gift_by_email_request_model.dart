import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_gift_by_email_request_model.freezed.dart';
part 'send_gift_by_email_request_model.g.dart';

@freezed
class SendGiftByEmailRequestModel with _$SendGiftByEmailRequestModel {
  factory SendGiftByEmailRequestModel({
    String? requestId,
    String? assetSymbol,
    @DecimalSerialiser() required Decimal amount,
    String? lang,
    String? toEmailAddress,
    String? pin,
  }) = _SendGiftByEmailRequestModel;

  factory SendGiftByEmailRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendGiftByEmailRequestModelFromJson(json);
}
