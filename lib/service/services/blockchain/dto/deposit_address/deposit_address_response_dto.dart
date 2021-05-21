import 'package:json_annotation/json_annotation.dart';

import '../../model/deposit_address/deposit_address_response_model.dart';

part 'deposit_address_response_dto.g.dart';

@JsonSerializable()
class DepositAddressResponseDto {
  DepositAddressResponseDto({
    required this.address,
    required this.memo,
    required this.memoType,
  });

  factory DepositAddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DepositAddressResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DepositAddressResponseDtoToJson(this);

  DepositAddressResponseModel toModel() {
    return DepositAddressResponseModel(
      address: address,
      memo: memo,
      memoType: memoType,
    );
  }

  final String address;
  final String memo;
  final String memoType;
}
