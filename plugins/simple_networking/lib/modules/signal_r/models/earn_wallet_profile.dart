import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_wallet_profile.freezed.dart';
part 'earn_wallet_profile.g.dart';

@Freezed()
class EarnWalletProfileModel with _$EarnWalletProfileModel {
  const factory EarnWalletProfileModel({
    @DecimalSerialiser() required Decimal balance,
    @DecimalSerialiser() required Decimal reserve,
    @DecimalSerialiser() required Decimal total,
  }) = _EarnWalletProfileModel;

  factory EarnWalletProfileModel.fromJson(Map<String, dynamic> json) => _$EarnWalletProfileModelFromJson(json);
}
