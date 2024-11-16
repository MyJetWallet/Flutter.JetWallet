import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_open_request.freezed.dart';

part 'push_notification_open_request.g.dart';

@freezed
class PushNotificationOpenRequestModel with _$PushNotificationOpenRequestModel {
  const factory PushNotificationOpenRequestModel({
    required String messageId,
    required String appVersion,
    required String device,
    required int status,
  }) = _PushNotificationOpenRequestModel;

  factory PushNotificationOpenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationOpenRequestModelFromJson(json);
}
