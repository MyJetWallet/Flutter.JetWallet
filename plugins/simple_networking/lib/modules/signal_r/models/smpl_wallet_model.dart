import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'smpl_wallet_model.freezed.dart';
part 'smpl_wallet_model.g.dart';

@freezed
class SmplWalletModel with _$SmplWalletModel {
  const factory SmplWalletModel({
    required SmplWalletProfileModel profile,
    @Default([]) List<SmplRequestModel> requests,
  }) = _SmplWalletModel;

  factory SmplWalletModel.fromJson(Map<String, dynamic> json) => _$SmplWalletModelFromJson(json);
}

@freezed
class SmplRequestModel with _$SmplRequestModel {
  const factory SmplRequestModel({
    required String id,
    @DecimalSerialiser() required Decimal amount,
  }) = _SmplRequestModel;

  factory SmplRequestModel.fromJson(Map<String, dynamic> json) => _$SmplRequestModelFromJson(json);
}

@freezed
class SmplWalletProfileModel with _$SmplWalletProfileModel {
  const factory SmplWalletProfileModel({
    String? id,
    @DecimalSerialiser() required Decimal balance,
  }) = _SmplWalletProfileModel;

  factory SmplWalletProfileModel.fromJson(Map<String, dynamic> json) => _$SmplWalletProfileModelFromJson(json);
}
