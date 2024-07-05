import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number_response_model.freezed.dart';
part 'phone_number_response_model.g.dart';

@freezed
class PhoneNumberResponseModel with _$PhoneNumberResponseModel {
  const factory PhoneNumberResponseModel({
    @JsonKey(name: 'data') required String number,
  }) = _PhoneNumberResponseModel;

  factory PhoneNumberResponseModel.fromJson(Map<String, dynamic> json) => _$PhoneNumberResponseModelFromJson(json);
}
