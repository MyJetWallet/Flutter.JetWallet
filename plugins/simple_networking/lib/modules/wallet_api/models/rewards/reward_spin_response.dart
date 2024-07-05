import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'reward_spin_response.freezed.dart';
part 'reward_spin_response.g.dart';

@freezed
class RewardSpinResponse with _$RewardSpinResponse {
  factory RewardSpinResponse({
    final String? assetSymbol,
    @DecimalNullSerialiser() Decimal? amount,
  }) = _RewardSpinResponse;

  factory RewardSpinResponse.fromJson(Map<String, dynamic> json) => _$RewardSpinResponseFromJson(json);
}
