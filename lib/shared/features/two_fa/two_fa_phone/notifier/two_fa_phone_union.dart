import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_phone_union.freezed.dart';

@freezed
class TwoFaPhoneUnion with _$TwoFaPhoneUnion {
  const factory TwoFaPhoneUnion.input() = Input;
  const factory TwoFaPhoneUnion.error(Object? error) = Error;
  const factory TwoFaPhoneUnion.loading() = Loading;
}
