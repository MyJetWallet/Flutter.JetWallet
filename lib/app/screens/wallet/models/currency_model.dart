import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.freezed.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    required String symbol,
    required String description,
    required double accuracy,
    required int depositMode,
    required int withdrawalMode,
    required int tagType,
    required String assetId,
    required double reserve,
    required String lastUpdate,
    required double sequenceId,
    required double assetBalance,
    required double baseBalance,
  }) = _CurrencyModel;

  const CurrencyModel._();

  bool get isDepositMode => depositMode == 0;

  bool get isWithdrawalMode => withdrawalMode == 0;
}
