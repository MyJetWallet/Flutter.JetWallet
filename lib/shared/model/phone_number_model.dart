import 'package:freezed_annotation/freezed_annotation.dart';

// part 'phone_number_model.freezed.dart';

@freezed
class PhoneNumberModel {
  PhoneNumberModel({
    required String isoCode,
    required String dialCode,
    required String body,
  });
}
