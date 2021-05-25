import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../screens/wallet/models/asset_with_balance_model.dart';

part 'convert_state.freezed.dart';

@freezed
class ConvertState with _$ConvertState {
  const factory ConvertState({
    required AssetWithBalanceModel from,
    required List<AssetWithBalanceModel> fromList,
    required AssetWithBalanceModel to,
    required List<AssetWithBalanceModel> toList,
    int? amount,
    int? quoteTime,
  }) = _ConvertState;
}
