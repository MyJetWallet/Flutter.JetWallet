import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'invest_wallet_model.freezed.dart';
part 'invest_wallet_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class InvestWalletModel with _$InvestWalletModel {
  const factory InvestWalletModel({
    @DecimalNullSerialiser() Decimal? balance,
    @DecimalNullSerialiser() Decimal? reserve,
    @DecimalNullSerialiser() Decimal? total,
  }) = _InvestWalletModel;

  factory InvestWalletModel.fromJson(Map<String, dynamic> json) =>
      _$InvestWalletModelFromJson(json);
}
