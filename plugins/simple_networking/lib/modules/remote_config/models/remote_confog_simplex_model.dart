import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_confog_simplex_model.freezed.dart';
part 'remote_confog_simplex_model.g.dart';

@freezed
class RemoteConfogSimplexModel with _$RemoteConfogSimplexModel {
  factory RemoteConfogSimplexModel({
    required String origin,
  }) = _RemoteConfogSimplexModel;

  factory RemoteConfogSimplexModel.fromJson(Map<String, dynamic> json) => _$RemoteConfogSimplexModelFromJson(json);
}
