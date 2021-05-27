import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/swap/model/get_quote/get_quote_response_model.dart';
import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import 'convert_union.dart';

part 'convert_state.freezed.dart';

@freezed
class ConvertState with _$ConvertState {
  const factory ConvertState({
    double? amount,
    Stream<int>? quoteTime,
    GetQuoteResponseModel? quoteResponse,
    @Default(RequestQuote()) ConvertUnion union,
    required TextEditingController amountTextController,
    required AssetWithBalanceModel from,
    required List<AssetWithBalanceModel> fromList,
    required AssetWithBalanceModel to,
    required List<AssetWithBalanceModel> toList,
  }) = _ConvertState;
}
