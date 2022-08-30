import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number_model.freezed.dart';

@freezed
class PhoneNumberModel with _$PhoneNumberModel {
  const factory PhoneNumberModel({
    required String isoCode,
    required String dialCode,
    required String body,
  }) = _PhoneNumberModel;
}
