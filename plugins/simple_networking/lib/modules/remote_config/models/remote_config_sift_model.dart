import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_sift_model.freezed.dart';
part 'remote_config_sift_model.g.dart';

@freezed
class RemoteConfigSiftModel with _$RemoteConfigSiftModel {
  factory RemoteConfigSiftModel({
    final String? siftBeaconKey,
    final String? siftAccountId,
  }) = _RemoteConfigSiftModel;

  factory RemoteConfigSiftModel.fromJson(Map<String, dynamic> json) => _$RemoteConfigSiftModelFromJson(json);
}
