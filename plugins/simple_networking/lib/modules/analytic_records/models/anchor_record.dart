import 'package:freezed_annotation/freezed_annotation.dart';

part 'anchor_record.freezed.dart';
part 'anchor_record.g.dart';

@freezed
class AnchorRecordModel with _$AnchorRecordModel {
  const factory AnchorRecordModel({
    required String anchorType,
    required Map<String, dynamic> metadata,
  }) = _AnchorRecordModel;

  factory AnchorRecordModel.fromJson(Map<String, dynamic> json) => _$AnchorRecordModelFromJson(json);
}
