import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation_history_union.freezed.dart';

@freezed
class OperationHistoryUnion with _$OperationHistoryUnion {
  const factory OperationHistoryUnion.loading() = Loading;
  const factory OperationHistoryUnion.loaded() = Loaded;
  const factory OperationHistoryUnion.error() = Error;
}
