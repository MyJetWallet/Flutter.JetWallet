import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_connection_flavor_model.freezed.dart';
part 'remote_config_connection_flavor_model.g.dart';

@freezed
class RemoteConfigConnectionFlavorModel
    with _$RemoteConfigConnectionFlavorModel {
  factory RemoteConfigConnectionFlavorModel({
    required final String candlesApi,
    required final String authApi,
    required final String walletApi,
    required final String walletApiSignalR,
    required final String validationApi,
    required final String iconApi,
  }) = _RemoteConfigConnectionFlavorModel;

  factory RemoteConfigConnectionFlavorModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RemoteConfigConnectionFlavorModelFromJson(json);
}
