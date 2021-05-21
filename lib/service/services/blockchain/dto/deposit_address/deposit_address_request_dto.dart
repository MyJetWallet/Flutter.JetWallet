import 'package:json_annotation/json_annotation.dart';

import '../../model/deposit_address/deposit_address_request_model.dart';

part 'deposit_address_request_dto.g.dart';

@JsonSerializable()
class DepositAddressRequestDto {
  DepositAddressRequestDto({
    required this.walletId,
    required this.assetSymbol,
  });

  factory DepositAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DepositAddressRequestDtoFromJson(json);

  factory DepositAddressRequestDto.fromModel(DepositAddressRequestModel model) {
    return DepositAddressRequestDto(
      walletId: model.walletId,
      assetSymbol: model.assetSymbol,
    );
  }

  Map<String, dynamic> toJson() => _$DepositAddressRequestDtoToJson(this);

  final String walletId;
  final String assetSymbol;
}
