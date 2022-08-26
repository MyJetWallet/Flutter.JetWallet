import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_sing_in_union.freezed.dart';

@freezed
class SingleSingInStateUnion with _$SingleSingInStateUnion {
  const factory SingleSingInStateUnion.input() = Input;
  const factory SingleSingInStateUnion.error(Object error) = Error;
  const factory SingleSingInStateUnion.errorString(String? error) = ErrorSrting;
  const factory SingleSingInStateUnion.loading() = Loading;
  const factory SingleSingInStateUnion.success() = Success;
}
