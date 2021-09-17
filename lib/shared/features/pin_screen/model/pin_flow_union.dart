import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_flow_union.freezed.dart';

@freezed
class PinFlowUnion with _$PinFlowUnion {
  const factory PinFlowUnion.change() = Change;
  const factory PinFlowUnion.disable() = Disable;
  const factory PinFlowUnion.enable() = Enable;
}
