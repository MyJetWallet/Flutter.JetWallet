import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_pay_confirm_model.freezed.dart';
part 'google_pay_confirm_model.g.dart';

@freezed
class GooglePayConfirmModel with _$GooglePayConfirmModel {
  factory GooglePayConfirmModel({
    final String? message,
    final String? redirectUrl,
  }) = _GooglePayConfirmModel;

  factory GooglePayConfirmModel.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfirmModelFromJson(json);
}
