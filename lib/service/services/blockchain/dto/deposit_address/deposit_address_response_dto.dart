import 'package:json_annotation/json_annotation.dart';

import '../../model/deposit_address/deposit_address_response_model.dart';

part 'deposit_address_response_dto.g.dart';

@JsonSerializable()
class DepositAddressResponseDto {
  DepositAddressResponseDto({
    this.address,
    this.memo,
    this.memoType,
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

  final String? address;
  final String? memo;
  final String? memoType;
}

@JsonSerializable()
class DepositAddressFullResponseDto {
  DepositAddressFullResponseDto({
    required this.result,
    this.data,
  });

  factory DepositAddressFullResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DepositAddressFullResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DepositAddressFullResponseDtoToJson(this);

  final String result;
  final DepositAddressResponseDto? data;
}
