import 'package:freezed_annotation/freezed_annotation.dart';

part 'signalr_log.freezed.dart';
part 'signalr_log.g.dart';

enum SLogType { startConnection, initMessage, ping, pong, error }

@Freezed(makeCollectionsUnmodifiable: false)
class SignalrLog with _$SignalrLog {
  factory SignalrLog({
    final DateTime? sessionTime,
    final List<SLogData>? logs,
  }) = _SignalrLog;

  factory SignalrLog.fromJson(Map<String, dynamic> json) => _$SignalrLogFromJson(json);
}

@freezed
class SLogData with _$SLogData {
  factory SLogData({
    final SLogType? type,
    final DateTime? date,
    final String? error,
  }) = _SLogData;

  factory SLogData.fromJson(Map<String, dynamic> json) => _$SLogDataFromJson(json);
}
