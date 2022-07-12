import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../helpers/input_helpers.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../model/contact_model.dart';

part 'send_by_phone_amount_state.freezed.dart';

@freezed
class SendByPhoneAmountState with _$SendByPhoneAmountState {
  const factory SendByPhoneAmountState({
    BaseCurrencyModel? baseCurrency,
    SKeyboardPreset? selectedPreset,
    String? tappedPreset,
    ContactModel? pickedContact,
    @Default('0') String amount,
    @Default('0') String baseConversionValue,
    @Default(false) bool valid,
    @Default(InputError.none) InputError inputError,
  }) = _SendByPhoneAmountState;
}
