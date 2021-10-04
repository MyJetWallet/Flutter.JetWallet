import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_union.freezed.dart';

@freezed
class RemoteConfigUnion with _$RemoteConfigUnion {
  const factory RemoteConfigUnion.success() = Success;
  const factory RemoteConfigUnion.loading() = Loading;
}
