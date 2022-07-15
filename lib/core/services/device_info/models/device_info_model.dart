import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info_model.freezed.dart';

@freezed
class DeviceInfoModel with _$DeviceInfoModel {
  const factory DeviceInfoModel({
    @Default('') String deviceUid,
    @Default('') String osName,
    @Default('') String version,
    @Default('') String manufacturer,
    @Default('') String model,
    @Default('') String sdk,
    @Default('') String name,
    @Default('') String marketingName,
  }) = _DeviceInfoModel;
}
