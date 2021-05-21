import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_address_request_model.freezed.dart';

@freezed
class DepositAddressRequestModel with _$DepositAddressRequestModel {
  const factory DepositAddressRequestModel({
    required String assetSymbol,
  }) = _DepositAddressRequestModel;
}
