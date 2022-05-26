import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_detail_model.freezed.dart';
part 'client_detail_model.g.dart';

@freezed
class ClientDetailModel with _$ClientDetailModel {
  const factory ClientDetailModel({
    @JsonKey(name: 'baseAsset') required String baseAssetSymbol,
    @Default(0) int depositStatus,
    @Default(0) int tradeStatus,
    @Default(0) int withdrawalStatus,
    @Default([]) List<int> requiredDocuments,
    @Default([]) List<int> requiredVerifications,
    @Default([]) List<ClientBlockerInfoModel> clientBlockers,
    required String walletCreationDate,
  }) = _ClientDetailModel;

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailModelFromJson(json);
}

@freezed
class ClientBlockerInfoModel with _$ClientBlockerInfoModel {
  const factory ClientBlockerInfoModel({
    required BlockingType blockingType,
    @JsonKey(name: 'toExpired') required String timespanToExpire,
  }) = _ClientBlockerInfoModel;

  factory ClientBlockerInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ClientBlockerInfoModelFromJson(json);
}

enum BlockingType {
  @JsonValue(0)
  withdrawal,
  @JsonValue(1)
  transfer,
  @JsonValue(2)
  trade,
  @JsonValue(3)
  login,
  @JsonValue(4)
  phoneNumberUpdate,
}
