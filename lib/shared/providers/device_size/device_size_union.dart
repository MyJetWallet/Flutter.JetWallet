import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_size_union.freezed.dart';

@freezed
class DeviceSizeUnion with _$DeviceSizeUnion {
  const factory DeviceSizeUnion.small() = Small;
  const factory DeviceSizeUnion.medium() = Medium;
}
