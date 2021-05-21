import 'package:json_annotation/json_annotation.dart';

import '../../model/withdrawal/withdrawal_request_model.dart';

part 'withdrawal_request_dto.g.dart';

@JsonSerializable()
class WithdrawalRequestDto {
  WithdrawalRequestDto({
    required this.requestId,
    required this.walletId,
    required this.assetSymbol,
    required this.amount,
    required this.toAddress,
  });

  factory WithdrawalRequestDto.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestDtoFromJson(json);

  factory WithdrawalRequestDto.fromModel(WithdrawalRequestModel model) {
    return WithdrawalRequestDto(
      requestId: model.requestId,
      walletId: model.walletId,
      assetSymbol: model.assetSymbol,
      amount: model.amount,
      toAddress: model.toAddress,
    );
  }

  Map<String, dynamic> toJson() => _$WithdrawalRequestDtoToJson(this);

  final String requestId;
  final String walletId;
  final String assetSymbol;
  final int amount;
  final String toAddress;
}
