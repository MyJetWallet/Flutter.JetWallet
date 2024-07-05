import 'package:freezed_annotation/freezed_annotation.dart';

part 'simplex_model.freezed.dart';
part 'simplex_model.g.dart';

@freezed
class SimplexModel with _$SimplexModel {
  const factory SimplexModel({
    required String origin,
  }) = _SimplexModel;

  factory SimplexModel.fromJson(Map<String, dynamic> json) => _$SimplexModelFromJson(json);
}
