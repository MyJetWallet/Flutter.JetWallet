import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_card_request_model.freezed.dart';
part 'add_card_request_model.g.dart';

@freezed
class AddCardRequestModel with _$AddCardRequestModel {
  const factory AddCardRequestModel({
    String? billingLine2,
    required String requestGuid,
    required String keyId,
    required String encryptedData,
    required String billingName,
    required String billingCity,
    required String billingCountry,
    required String billingLine1,
    required String billingDistrict,
    required String billingPostalCode,
    required int expMonth,
    required int expYear,
  }) = _AddCardRequestModel;

  factory AddCardRequestModel.fromJson(Map<String, dynamic> json) => _$AddCardRequestModelFromJson(json);
}
