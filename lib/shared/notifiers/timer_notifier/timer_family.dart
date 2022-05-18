import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'timer_family.freezed.dart';

@freezed
class TimerFamily with _$TimerFamily {
  const factory TimerFamily({
    required String id,
    required int duration,
  }) = _TimerFamily;
}

TimerFamily timerFamily(int duration) {
  return TimerFamily(
    id: const Uuid().v1(),
    duration: 3,
  );
}
