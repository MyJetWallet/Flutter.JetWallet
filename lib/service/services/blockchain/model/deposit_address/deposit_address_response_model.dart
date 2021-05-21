import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_address_response_model.freezed.dart';

@freezed
class DepositAddressResponseModel with _$DepositAddressResponseModel {
  const factory DepositAddressResponseModel({
    required String address,
    required String memo,
    required String memoType,
  }) = _DepositAddressResponseModel;
}
