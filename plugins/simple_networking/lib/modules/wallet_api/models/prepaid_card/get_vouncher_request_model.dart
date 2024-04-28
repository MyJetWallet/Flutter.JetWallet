import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_vouncher_request_model.freezed.dart';
part 'get_vouncher_request_model.g.dart';

@freezed
class GetVouncherRequestModel with _$GetVouncherRequestModel {
  const factory GetVouncherRequestModel({
    required String orderId,
  }) = _GetVouncherRequestModel;

  factory GetVouncherRequestModel.fromJson(Map<String, dynamic> json) => _$GetVouncherRequestModelFromJson(json);
}
