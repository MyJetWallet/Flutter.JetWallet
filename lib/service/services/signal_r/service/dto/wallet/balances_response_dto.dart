import 'package:json_annotation/json_annotation.dart';

import '../../model/wallet/balance_model.dart';

part 'balances_response_dto.g.dart';

@JsonSerializable()
class BalancesDto {
  BalancesDto({required this.balances});

  factory BalancesDto.fromJson(Map<String, dynamic> json) => _$BalancesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BalancesDtoToJson(this);

  BalancesModel toModel() => BalancesModel(
      balances: balances
          .map((balance) => BalanceModel(
                assetId: balance.assetId,
                balance: balance.balance,
                reserve: balance.reserve,
                lastUpdate: balance.lastUpdate,
                sequenceId: balance.sequenceId,
              ))
          .toList());

  List<BalanceDto> balances;
}

@JsonSerializable()
class BalanceDto {
  BalanceDto({
    required this.assetId,
    required this.balance,
    required this.reserve,
    required this.lastUpdate,
    required this.sequenceId,
  });

  factory BalanceDto.fromJson(Map<String, dynamic> json) => _$BalanceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceDtoToJson(this);

  String assetId;
  num balance;
  num reserve;
  String lastUpdate;
  num sequenceId;
}
