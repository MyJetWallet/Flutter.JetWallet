import 'package:freezed_annotation/freezed_annotation.dart';

part 'road_map_steep_model.freezed.dart';
part 'road_map_steep_model.g.dart';

@freezed
class RoadmapStepModel with _$RoadmapStepModel {
  factory RoadmapStepModel({
    required String title,
    required bool isCompleted,
    String? schedule,
    @Default(false) bool isFirst,
    @Default(false) bool isLast,
    @Default(false) bool isPreviosCompleted,
  }) = _RoadmapStepModel;

  factory RoadmapStepModel.fromJson(Map<String, dynamic> json) => _$RoadmapStepModelFromJson(json);
}
