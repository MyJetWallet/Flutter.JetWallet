import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_nft_model.freezed.dart';
part 'remote_config_nft_model.g.dart';

@freezed
class RemoteConfigNftModel with _$RemoteConfigNftModel {
  factory RemoteConfigNftModel({
    required String shortUrl,
    required String fullUrl,
    required String shareLink,
  }) = _RemoteConfigNftModel;

  factory RemoteConfigNftModel.fromJson(Map<String, dynamic> json) => _$RemoteConfigNftModelFromJson(json);
}
