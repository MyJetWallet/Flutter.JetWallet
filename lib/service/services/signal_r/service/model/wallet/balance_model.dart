import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_model.freezed.dart';

@freezed
class BalancesModel with _$BalancesModel {
  const factory BalancesModel({required List<BalanceModel> balances}) = _BalancesModel;
}

@freezed
class BalanceModel with _$BalanceModel {
  const factory BalanceModel({
    required String assetId,
    required num balance,
    required num reserve,
    required String lastUpdate,
    required num sequenceId,
  }) = _BalanceModel;
}
