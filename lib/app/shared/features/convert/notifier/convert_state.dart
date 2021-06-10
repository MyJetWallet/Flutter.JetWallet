import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../screens/wallet/model/currency_model.dart';
import 'convert_union.dart';

part 'convert_state.freezed.dart';

@freezed
class ConvertState with _$ConvertState {
  const factory ConvertState({
    double? amount,
    GetQuoteResponseModel? quoteResponse,
    @Default(false) bool isConfirmLoading,
    @Default(RequestQuote()) ConvertUnion union,
    required TextEditingController amountTextController,
    required CurrencyModel from,
    required List<CurrencyModel> fromList,
    required CurrencyModel to,
    required List<CurrencyModel> toList,
  }) = _ConvertState;
}
