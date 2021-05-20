import 'package:freezed_annotation/freezed_annotation.dart';

part 'router_union.freezed.dart';

@freezed
class RouterUnion with _$RouterUnion {
  const factory RouterUnion.authorised() = Authorised;
  const factory RouterUnion.unauthorised() = Unauthorised;
}
