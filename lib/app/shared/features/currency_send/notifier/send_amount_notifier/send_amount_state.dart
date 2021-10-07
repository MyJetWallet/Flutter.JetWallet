import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../helpers/input_helpers.dart';
import '../../../../providers/base_currency_pod/base_currency_model.dart';

part 'send_amount_state.freezed.dart';

@freezed
class SendAmountState with _$SendAmountState {
  const factory SendAmountState({
    BaseCurrencyModel? baseCurrency,
    @Default('0') String amount,
    @Default('0') String baseConversionValue,
    @Default(false) bool valid,
    @Default(InputError.none) InputError inputError,
  }) = _SendAmountState;
}
