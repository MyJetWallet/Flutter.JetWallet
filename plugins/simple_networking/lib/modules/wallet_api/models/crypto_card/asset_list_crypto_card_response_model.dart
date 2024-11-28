import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_list_crypto_card_response_model.freezed.dart';
part 'asset_list_crypto_card_response_model.g.dart';

@freezed
class AssetListCryptoCardResponseModel with _$AssetListCryptoCardResponseModel {
  const factory AssetListCryptoCardResponseModel({
    @Default([]) List<String> assets,
  }) = _AssetListCryptoCardResponseModel;

  factory AssetListCryptoCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssetListCryptoCardResponseModelFromJson(json);
}
