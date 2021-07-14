import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info_response_model.freezed.dart';
part 'server_info_response_model.g.dart';

@freezed
class ServerInfoResponseModel with _$ServerInfoResponseModel {
  const factory ServerInfoResponseModel({
    required String tradingUrl,
    required String connectionTimeOut,
    required String reconnectTimeOut,
    @JsonKey(name: 'serverDateTime') required String serverTime,
  }) = _ServerInfoResponseModel;

  factory ServerInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ServerInfoResponseModelFromJson(json);
}
