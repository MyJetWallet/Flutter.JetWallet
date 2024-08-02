import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_address_request_model.freezed.dart';
part 'deposit_address_request_model.g.dart';

@freezed
class DepositAddressRequestModel with _$DepositAddressRequestModel {
  const factory DepositAddressRequestModel({
    required String assetSymbol,
    required String blockchain,
  }) = _DepositAddressRequestModel;

  factory DepositAddressRequestModel.fromJson(Map<String, dynamic> json) => _$DepositAddressRequestModelFromJson(json);
}
