import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_card_message_model.freezed.dart';
part 'crypto_card_message_model.g.dart';

@freezed
class CryptoCardProfile with _$CryptoCardProfile {
  const factory CryptoCardProfile({
    @Default(CryptoCardProfileStatus.undefined)
    @JsonKey(unknownEnumValue: CryptoCardProfileStatus.undefined)
    CryptoCardProfileStatus status,
    @Default([]) List<String> associateAssetList,
    @Default(0) int availableCardsCount,
    @Default([]) List<CryptoCardModel> cards,
  }) = _CryptoCardProfile;

  factory CryptoCardProfile.fromJson(Map<String, dynamic> json) => _$CryptoCardProfileFromJson(json);
}

enum CryptoCardProfileStatus {
  @JsonValue(0)
  active,
  @JsonValue(1)
  blocked,
  @JsonValue(2)
  kycRequired,
  @JsonValue(3)
  kycInProgress,
  @JsonValue(-1)
  undefined,
}

@freezed
class CryptoCardModel with _$CryptoCardModel {
  const factory CryptoCardModel({
    @Default('') String cardId,
    @Default('') String last4,
    @Default(CryptoCardStatus.undefined) @JsonKey(unknownEnumValue: CryptoCardStatus.undefined) CryptoCardStatus status,
    @Default('') String label,
  }) = _CryptoCardModel;

  factory CryptoCardModel.fromJson(Map<String, dynamic> json) => _$CryptoCardModelFromJson(json);
}

enum CryptoCardStatus {
  @JsonValue(0)
  inCreation,
  @JsonValue(1)
  active,
  @JsonValue(2)
  frozen,
  @JsonValue(3)
  closed,
  @JsonValue(-1)
  undefined,
}
