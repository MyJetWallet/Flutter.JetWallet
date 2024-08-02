import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_user_data_request_model.freezed.dart';
part 'apply_user_data_request_model.g.dart';

@freezed
class ApplyUseDataRequestModel with _$ApplyUseDataRequestModel {
  const factory ApplyUseDataRequestModel({
    required String lastName,
    required String firstName,
    required String dateOfBirth,
    required String countyOfResidence,
    required String? referralCode,
  }) = _ApplyUseDataRequestModel;

  factory ApplyUseDataRequestModel.fromJson(Map<String, dynamic> json) => _$ApplyUseDataRequestModelFromJson(json);
}
