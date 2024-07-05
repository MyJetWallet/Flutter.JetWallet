import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'balance_model.freezed.dart';
part 'balance_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BalancesModel with _$BalancesModel {
  const factory BalancesModel({
    required List<BalanceModel> balances,
  }) = _BalancesModel;

  factory BalancesModel.fromJson(Map<String, dynamic> json) => _$BalancesModelFromJson(json);
}

@freezed
class BalanceModel with _$BalanceModel {
  const factory BalanceModel({
    required String assetId,
    @DecimalSerialiser() required Decimal balance,
    required String lastUpdate,
    @DecimalSerialiser() required Decimal totalEarnAmount,
    @DecimalSerialiser() required Decimal cardReserve,
    @DecimalSerialiser() required Decimal currentEarnAmount,
    required String nextPaymentDate,
    @DecimalSerialiser() required Decimal apy,
    @DecimalSerialiser() required Decimal apr,
    @DecimalSerialiser() required Decimal depositInProcess,
    @DecimalSerialiser() required Decimal buysInProcessTotal,
    @DecimalSerialiser() required Decimal transfersInProcessTotal,
    @DecimalSerialiser() required Decimal earnInProcessTotal,
    required int buysInProcessCount,
    required int transfersInProcessCount,
    required int earnInProcessCount,
  }) = _BalanceModel;

  factory BalanceModel.fromJson(Map<String, dynamic> json) => _$BalanceModelFromJson(json);
}
