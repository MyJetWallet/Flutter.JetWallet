import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization_union.freezed.dart';

@freezed
class AuthorizationUnion with _$AuthorizationUnion {
  const factory AuthorizationUnion.authorized() = Authorized;
  const factory AuthorizationUnion.unauthorized() = Unauthorized;
}
