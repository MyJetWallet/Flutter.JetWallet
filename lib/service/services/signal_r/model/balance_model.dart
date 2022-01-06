import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_model.freezed.dart';
part 'balance_model.g.dart';

@freezed
class BalancesModel with _$BalancesModel {
  const factory BalancesModel({
    required List<BalanceModel> balances,
  }) = _BalancesModel;

  factory BalancesModel.fromJson(Map<String, dynamic> json) =>
      _$BalancesModelFromJson(json);
}

@freezed
class BalanceModel with _$BalanceModel {
  const factory BalanceModel({
    required String assetId,
    required double balance,
    required double reserve,
    required String lastUpdate,
    required double sequenceId,
    required double totalEarnAmount,
    required double currentEarnAmount,
    required String nextPaymentDate,
    required double apy,
  }) = _BalanceModel;

  factory BalanceModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceModelFromJson(json);
}
