import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/contact_model.dart';

part 'send_by_phone_input_state.freezed.dart';

@freezed
class SendByPhoneInputState with _$SendByPhoneInputState {
  const factory SendByPhoneInputState({
    @Default('') String code,
    @Default('') String phoneNumber,
    @Default([]) List<ContactModel> contacts,
  }) = _SendByPhoneInputState;
}
