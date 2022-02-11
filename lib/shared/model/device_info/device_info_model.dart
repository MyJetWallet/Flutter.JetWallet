import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info_model.freezed.dart';

@freezed
class DeviceInfoModel with _$DeviceInfoModel {
  const factory DeviceInfoModel({
    required String deviceUid,
    required String osName,
    required String version,
    required String manufacturer,
    required String model,
    @Default('') String sdk,
    @Default('') String name,
  }) = _DeviceInfoModel;
}
