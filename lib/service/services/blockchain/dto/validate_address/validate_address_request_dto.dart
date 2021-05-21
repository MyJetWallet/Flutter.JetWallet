import 'package:json_annotation/json_annotation.dart';

import '../../model/validate_address/validate_address_request_model.dart';

part 'validate_address_request_dto.g.dart';

@JsonSerializable()
class ValidateAddressRequestDto {
  ValidateAddressRequestDto({
    required this.walletId,
    required this.assetSymbol,
    required this.toAddress,
  });

  factory ValidateAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateAddressRequestDtoFromJson(json);

  factory ValidateAddressRequestDto.fromModel(
    ValidateAddressRequestModel model,
  ) {
    return ValidateAddressRequestDto(
      walletId: model.walletId,
      assetSymbol: model.assetSymbol,
      toAddress: model.toAddress,
    );
  }

  Map<String, dynamic> toJson() => _$ValidateAddressRequestDtoToJson(this);

  final String walletId;
  final String assetSymbol;
  final String toAddress;
}
