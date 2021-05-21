import 'package:json_annotation/json_annotation.dart';

import '../../model/withdrawal/withdrawal_response_model.dart';

part 'withdrawal_response_dto.g.dart';

@JsonSerializable()
class WithdrawalResponseDto {
  WithdrawalResponseDto({
    required this.operationId,
    required this.txId,
    required this.txUrl,
  });

  factory WithdrawalResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalResponseDtoToJson(this);

  WithdrawalResponseModel toModel() {
    return WithdrawalResponseModel(
      operationId: operationId,
      txId: txId,
      txUrl: txUrl,
    );
  }

  final String operationId;
  final String txId;
  final String txUrl;
}
