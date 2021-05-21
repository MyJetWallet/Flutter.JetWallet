import 'package:freezed_annotation/freezed_annotation.dart';

part 'validate_address_request_model.freezed.dart';

@freezed
class ValidateAddressRequestModel with _$ValidateAddressRequestModel {
  const factory ValidateAddressRequestModel({
    required String walletId,
    required String assetSymbol,
    required String toAddress,
  }) = _ValidateAddressRequestModel;
}
