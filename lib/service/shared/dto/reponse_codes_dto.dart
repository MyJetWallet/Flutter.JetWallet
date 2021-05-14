import 'package:json_annotation/json_annotation.dart';

part 'reponse_codes_dto.g.dart';

@JsonSerializable()
class ResponseCodesDto {
  ResponseCodesDto({
    required this.result,
  });

  factory ResponseCodesDto.fromJson(Map<String, dynamic> json) =>
      _$ResponseCodesDtoFromJson(json);

  final ApiResponseCodes result;
}

enum ApiResponseCodes {
  @JsonValue('OK')
  ok,
  @JsonValue('InternalServerError')
  internalServerError,
  @JsonValue('WalletDoNotExist')
  walletDoNotExist,
  @JsonValue('LowBalance')
  lowBalance,
  @JsonValue('CannotProcessWithdrawal')
  cannotProcessWithdrawal,
  @JsonValue('AddressIsNotValid')
  addressIsNotValid,
  @JsonValue('AssetDoNotFound')
  assetDoNotFound,
  @JsonValue('AssetIsDisabled')
  assetIsDisabled,
  @JsonValue('AmountIsSmall')
  amountIsSmall,
  @JsonValue('InvalidInstrument')
  invalidInstrument,
  @JsonValue('KycNotPassed')
  kycNotPassed,
  @JsonValue('AssetDoNotSupported')
  assetDoNotSupported,
  @JsonValue('NotEnoughLiquidityForMarketOrder')
  notEnoughLiquidityForMarketOrder,
  @JsonValue('InvalidOrderValue')
  invalidOrderValue
}
