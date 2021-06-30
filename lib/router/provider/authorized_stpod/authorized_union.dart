import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorized_union.freezed.dart';

@freezed
class AuthorizedUnion with _$AuthorizedUnion{
  const factory AuthorizedUnion.initial() = Initial;
  const factory AuthorizedUnion.home() = Home;
  const factory AuthorizedUnion.emailVerification() = EmailVerification;
}
