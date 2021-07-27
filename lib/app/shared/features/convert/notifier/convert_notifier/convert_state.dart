import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';

import 'convert_union.dart';

part 'convert_state.freezed.dart';

@freezed
class ConvertState with _$ConvertState {
  const factory ConvertState({
    GetQuoteResponseModel? responseQuote,
    String? error,
    @Default(QuoteLoading()) ConvertUnion union,
    @Default(0) int timer,
  }) = _ConvertState;
}
