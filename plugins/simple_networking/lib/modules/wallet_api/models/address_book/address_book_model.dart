import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_book_model.freezed.dart';
part 'address_book_model.g.dart';

@freezed
class AddressBookModel with _$AddressBookModel {
  factory AddressBookModel({
    final List<AddressBookContactModel>? contacts,
    final List<AddressBookContactModel>? topContacts,
  }) = _AddressBookModel;

  factory AddressBookModel.fromJson(Map<String, dynamic> json) =>
      _$AddressBookModelFromJson(json);
}

@freezed
class AddressBookContactModel with _$AddressBookContactModel {
  factory AddressBookContactModel({
    final String? id,
    final String? name,
    final String? nickname,
    final String? iban,
    final String? bic,
    final String? bankName,
    final int? weight,
  }) = _AddressBookContactModel;

  factory AddressBookContactModel.fromJson(Map<String, dynamic> json) =>
      _$AddressBookContactModelFromJson(json);
}
