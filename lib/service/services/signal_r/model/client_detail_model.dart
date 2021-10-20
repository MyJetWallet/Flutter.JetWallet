import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_detail_model.freezed.dart';
part 'client_detail_model.g.dart';

@freezed
class ClientDetailModel with _$ClientDetailModel {
  const factory ClientDetailModel({
    @JsonKey(name: 'baseAsset') required String baseAssetSymbol,
    required String walletCreationDate,
  }) = _ClientDetailModel;

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailModelFromJson(json);
}
