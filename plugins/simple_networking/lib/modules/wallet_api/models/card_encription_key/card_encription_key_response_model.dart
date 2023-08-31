import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_encription_key_response_model.freezed.dart';
part 'card_encription_key_response_model.g.dart';

@freezed
class EncryptionKeyCardResponseModel with _$EncryptionKeyCardResponseModel {
  const factory EncryptionKeyCardResponseModel({
    required EncryptionKeyCardResponseDataModel data,
  }) = _EncryptionKeyCardResponseModel;

  factory EncryptionKeyCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EncryptionKeyCardResponseModelFromJson(json);
}

@freezed
class EncryptionKeyCardResponseDataModel
    with _$EncryptionKeyCardResponseDataModel {
  const factory EncryptionKeyCardResponseDataModel({
    required String keyId,
    required String key,
  }) = _EncryptionKeyCardResponseDataModel;

  factory EncryptionKeyCardResponseDataModel.fromJson(
          Map<String, dynamic> json) =>
      _$EncryptionKeyCardResponseDataModelFromJson(json);
}
