import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_model.freezed.dart';
part 'support_model.g.dart';

@freezed
class SupportModel with _$SupportModel {
  const factory SupportModel({
    required String faqLink,
    required String crispWebsiteId,
  }) = _SupportModel;

  factory SupportModel.fromJson(Map<String, dynamic> json) => _$SupportModelFromJson(json);
}
