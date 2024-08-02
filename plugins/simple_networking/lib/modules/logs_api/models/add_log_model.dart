import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_log_model.freezed.dart';
part 'add_log_model.g.dart';

@freezed
class AddLogModel with _$AddLogModel {
  factory AddLogModel({
    String? level,
    String? message,
    String? source,
    String? process,
    String? token,
  }) = _AddLogModel;

  factory AddLogModel.fromJson(Map<String, dynamic> json) => _$AddLogModelFromJson(json);
}
