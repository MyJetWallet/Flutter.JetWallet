import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_connection_flavor_model.freezed.dart';
part 'remote_config_connection_flavor_model.g.dart';

@freezed
class RemoteConfigConnectionFlavorModel
    with _$RemoteConfigConnectionFlavorModel {
  factory RemoteConfigConnectionFlavorModel({
    required String candlesApi,
    required String authApi,
    required String walletApi,
    required String walletApiSignalR,
    required String validationApi,
    required String iconApi,
  }) = _RemoteConfigConnectionFlavorModel;

  factory RemoteConfigConnectionFlavorModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RemoteConfigConnectionFlavorModelFromJson(json);
}
