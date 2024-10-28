import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/core/services/anchors/anchors_service.dart';

part 'crypto_deposit_model.freezed.dart';
part 'crypto_deposit_model.g.dart';

///
/// Model created for [AnchorsService]
/// Any changes must be coordinated with all developers
///

@freezed
class CryptoDepositModel with _$CryptoDepositModel {
  const factory CryptoDepositModel({
    required String assetSymbol,
  }) = _CryptoDepositModel;

  factory CryptoDepositModel.fromJson(Map<String, dynamic> json) => _$CryptoDepositModelFromJson(json);
}
