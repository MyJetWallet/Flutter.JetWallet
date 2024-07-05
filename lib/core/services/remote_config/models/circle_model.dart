import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_model.freezed.dart';
part 'circle_model.g.dart';

@freezed
class CircleModel with _$CircleModel {
  const factory CircleModel({
    required bool cvvEnabled,
  }) = _CircleModel;

  factory CircleModel.fromJson(Map<String, dynamic> json) => _$CircleModelFromJson(json);
}
