import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_user_data_response_model.freezed.dart';
part 'apply_user_data_response_model.g.dart';

@freezed
class ApplyUseDataResponseModel with _$ApplyUseDataResponseModel {
  const factory ApplyUseDataResponseModel({
    required String? result,
  }) = _ApplyUseDataResponseModel;

  factory ApplyUseDataResponseModel.fromJson(Map<String, dynamic> json) => _$ApplyUseDataResponseModelFromJson(json);
}
