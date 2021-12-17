import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    @Default(true) bool valid,
    required String name,
    required String phoneNumber,
  }) = _ContactModel;
}
