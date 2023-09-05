import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_verification_request_model.freezed.dart';
part 'card_verification_request_model.g.dart';

@freezed
class CardVerificationRequestModel with _$CardVerificationRequestModel {
  const factory CardVerificationRequestModel({
    required String verificationId,
  }) = _CardVerificationRequestModel;

  factory CardVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CardVerificationRequestModelFromJson(json);
}
