import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_time_model.freezed.dart';

@freezed
class ServerTimeModel with _$ServerTimeModel {
  const factory ServerTimeModel({
    required double now,
  }) = _ServerTimeModel;
}