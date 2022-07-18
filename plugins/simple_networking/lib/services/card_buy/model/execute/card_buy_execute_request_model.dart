import 'package:freezed_annotation/freezed_annotation.dart';

import '../create/card_buy_create_request_model.dart';

part 'card_buy_execute_request_model.freezed.dart';
part 'card_buy_execute_request_model.g.dart';

@freezed
class CardBuyExecuteRequestModel with _$CardBuyExecuteRequestModel {
  const factory CardBuyExecuteRequestModel({
    String? paymentId,
    required CirclePaymentMethod paymentMethod,
    CirclePaymentDataExecuteModel? circlePaymentData,
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
