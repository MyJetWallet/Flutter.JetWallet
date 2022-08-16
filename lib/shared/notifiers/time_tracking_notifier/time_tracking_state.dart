import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_tracking_state.freezed.dart';

@freezed
class TimeTrackingState with _$TimeTrackingState {
  const factory TimeTrackingState({
    DateTime? startApp,
    DateTime? marketOpened,
    DateTime? signalRStarted,
    DateTime? initFinishedFirstCheck,
    DateTime? initFinishedReceived,
    DateTime? configReceived,
    @Default(false) bool timeStartMarketSent,
    @Default(false) bool timeStartInitFinishedSent,
    @Default(false) bool timeStartConfigSent,
    @Default(false) bool timeSignalRCheckIFSent,
    @Default(false) bool timeSignalRReceiveIFSent,
    @Default(false) bool initFinishedOnMarketSent,
  }) = _TimeTrackingState;
}
