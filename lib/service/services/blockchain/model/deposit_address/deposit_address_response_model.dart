import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_address_response_model.freezed.dart';

@freezed
class DepositAddressResponseModel with _$DepositAddressResponseModel {
  const factory DepositAddressResponseModel({
    String? address,
    String? memo,
    String? memoType,
  }) = _DepositAddressResponseModel;
}
