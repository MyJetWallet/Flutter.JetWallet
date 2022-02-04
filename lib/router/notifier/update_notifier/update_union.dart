import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_union.freezed.dart';

@freezed
class UpdateUnion with _$UpdateUnion {
  const factory UpdateUnion.showingAlert() = ShowingAlert;
  const factory UpdateUnion.noUpdates() = NoUpdates;
}
