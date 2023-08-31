import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';

part 'card_buy_execute_request_model.freezed.dart';
part 'card_buy_execute_request_model.g.dart';

@freezed
class CardBuyExecuteRequestModel with _$CardBuyExecuteRequestModel {
  const factory CardBuyExecuteRequestModel({
    String? paymentId,
    required CirclePaymentMethod paymentMethod,
    CirclePaymentDataExecuteModel? circlePaymentData,
    UnlimintPaymentDataExecuteModel? unlimintPaymentData,
    UnlimintAltPaymentDataExecuteModel? unlimintAlternativePaymentData,
    BankCardPaymentDataExecuteModel? cardPaymentData,
  }) = _CardBuyExecuteRequestModel;

  factory CardBuyExecuteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CardBuyExecuteRequestModelFromJson(json);
}

@freezed
class CirclePaymentDataExecuteModel with _$CirclePaymentDataExecuteModel {
  const factory CirclePaymentDataExecuteModel({
    String? cardId,
    String? keyId,
    String? encryptedData,
  }) = _CirclePaymentDataExecuteModel;

  factory CirclePaymentDataExecuteModel.fromJson(Map<String, dynamic> json) =>
      _$CirclePaymentDataExecuteModelFromJson(json);
}

@freezed
class UnlimintPaymentDataExecuteModel with _$UnlimintPaymentDataExecuteModel {
  const factory UnlimintPaymentDataExecuteModel({
    String? cardId,
  }) = _UnlimintPaymentDataExecuteModel;

  factory UnlimintPaymentDataExecuteModel.fromJson(Map<String, dynamic> json) =>
      _$UnlimintPaymentDataExecuteModelFromJson(json);
}

@freezed
class UnlimintAltPaymentDataExecuteModel
    with _$UnlimintAltPaymentDataExecuteModel {
  const factory UnlimintAltPaymentDataExecuteModel({
    String? locale,
  }) = _UnlimintAltPaymentDataExecuteModel;

  factory UnlimintAltPaymentDataExecuteModel.fromJson(
          Map<String, dynamic> json) =>
      _$UnlimintAltPaymentDataExecuteModelFromJson(json);
}

@freezed
class BankCardPaymentDataExecuteModel with _$BankCardPaymentDataExecuteModel {
  const factory BankCardPaymentDataExecuteModel({
    String? cardId,
    String? encKeyId,
    String? encData,
  }) = _BankCardPaymentDataExecuteModel;

  factory BankCardPaymentDataExecuteModel.fromJson(Map<String, dynamic> json) =>
      _$BankCardPaymentDataExecuteModelFromJson(json);
}
