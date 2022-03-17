import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'send_by_phone_confirm_union.dart';

part 'send_by_phone_confirm_state.freezed.dart';

@freezed
class SendByPhoneConfirmState with _$SendByPhoneConfirmState {
  const factory SendByPhoneConfirmState({
    @Default(Input()) SendByPhoneConfirmUnion union,
    @Default(false) bool isResending,
    required TextEditingController controller,
  }) = _SendByPhoneConfirmState;
}
