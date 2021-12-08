import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_model.freezed.dart';
part 'reward_model.g.dart';

@freezed
class RewardModel with _$RewardModel {
  const factory RewardModel({
    String? asset,
    required double amount,
  }) = _RewardModel;

  factory RewardModel.fromJson(Map<String, dynamic> json) =>
      _$RewardModelFromJson(json);
}
