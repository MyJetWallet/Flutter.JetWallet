import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_support_model.freezed.dart';
part 'remote_config_support_model.g.dart';

@freezed
class RemoteConfigSupportModel with _$RemoteConfigSupportModel {
  factory RemoteConfigSupportModel({
    String? faqLink,
    String? crispWebsiteId,
    bool? showZendesk,
    String? zendeskIOS,
    String? zendeskAndroid,
  }) = _RemoteConfigSupportModel;

  factory RemoteConfigSupportModel.fromJson(Map<String, dynamic> json) => _$RemoteConfigSupportModelFromJson(json);
}
