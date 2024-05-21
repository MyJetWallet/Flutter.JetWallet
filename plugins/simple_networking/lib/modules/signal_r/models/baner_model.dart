import 'package:freezed_annotation/freezed_annotation.dart';

part 'baner_model.freezed.dart';
part 'baner_model.g.dart';

@freezed
class BanersListMessage with _$BanersListMessage {
  const factory BanersListMessage({
    @Default([]) List<BanerModel> banners,
  }) = _BanersListMessage;

  factory BanersListMessage.fromJson(Map<String, dynamic> json) => _$BanersListMessageFromJson(json);
}

@freezed
class BanerModel with _$BanerModel {
  const factory BanerModel({
    required String bannerId,
    @Default('') String title,
    @Default('') String description,
    String? cta,
    String? image,
    @Default(0.5) double align,
    String? action,
    @Default(BanerType.unclosable) @JsonKey(unknownEnumValue: BanerType.unclosable) BanerType type,
    required int order,
  }) = _BanerModel;

  factory BanerModel.fromJson(Map<String, dynamic> json) => _$BanerModelFromJson(json);
}

enum BanerType {
  @JsonValue(1)
  closable,
  @JsonValue(2)
  unclosable,
}
