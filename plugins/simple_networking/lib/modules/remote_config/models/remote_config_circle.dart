import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_circle.freezed.dart';
part 'remote_config_circle.g.dart';

@freezed
class RemoteConfigCircle with _$RemoteConfigCircle {
  factory RemoteConfigCircle({
    required bool cvvEnabled,
  }) = _RemoteConfigCircle;

  factory RemoteConfigCircle.fromJson(Map<String, dynamic> json) => _$RemoteConfigCircleFromJson(json);
}
