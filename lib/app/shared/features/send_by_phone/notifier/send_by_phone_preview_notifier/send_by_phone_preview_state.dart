import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/contact_model.dart';

part 'send_by_phone_preview_state.freezed.dart';

@freezed
class SendByPhonePreviewState with _$SendByPhonePreviewState {
  const factory SendByPhonePreviewState({
    ContactModel? pickedContact,
    @Default('0') String amount,

    /// Needed to track status of the operation on ConfirmScreen
    @Default('') String operationId,
    @Default(false) bool loading,
  }) = _SendByPhonePreviewState;
}
