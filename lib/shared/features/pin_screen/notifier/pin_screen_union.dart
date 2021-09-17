import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_screen_union.freezed.dart';

@freezed
class PinScreenUnion with _$PinScreenUnion {
  const factory PinScreenUnion.enterPin() = EnterPin;
  const factory PinScreenUnion.newPin() = NewPin;
  const factory PinScreenUnion.confirmPin() = ConfirmPin;
}
