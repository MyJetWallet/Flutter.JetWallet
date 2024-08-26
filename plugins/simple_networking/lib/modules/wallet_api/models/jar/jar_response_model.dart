import 'package:freezed_annotation/freezed_annotation.dart';

part 'jar_response_model.freezed.dart';

part 'jar_response_model.g.dart';

@freezed
class JarResponseModel with _$JarResponseModel {
  const factory JarResponseModel({
    required String id,
    required String? tokenId,
    required double balance,
    required double target,
    required String assetSymbol,
    required String? imageUrl,
    required String? ownerName,
    required String title,
    required String description,
    @JsonKey(unknownEnumValue: JarStatus.creating) required JarStatus status,
    required List<JarAddressModel> addresses,
  }) = _JarResponseModel;

  factory JarResponseModel.fromJson(Map<String, dynamic> json) => _$JarResponseModelFromJson(json);
}

@freezed
class JarAddressModel with _$JarAddressModel {
  const factory JarAddressModel({
    required String address,
    required String tag,
    required String blockchain,
    required String assetSymbol,
  }) = _JarAddressModel;

  factory JarAddressModel.fromJson(Map<String, dynamic> json) => _$JarAddressModelFromJson(json);
}

enum JarStatus {
  @JsonValue(0)
  active,
  @JsonValue(1)
  closed,
  @JsonValue(2)
  creating,
}