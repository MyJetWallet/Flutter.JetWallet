import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_flavor_model.freezed.dart';
part 'connection_flavor_model.g.dart';

@freezed
class ConnectionFlavorsModel with _$ConnectionFlavorsModel {
  const factory ConnectionFlavorsModel({
    required List<ConnectionFlavorModel> flavors,
  }) = _ConnectionFlavorsModel;

  factory ConnectionFlavorsModel.fromList(List list) {
    return ConnectionFlavorsModel(
      flavors: list
          .map((e) => ConnectionFlavorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@freezed
class ConnectionFlavorModel with _$ConnectionFlavorModel {
  const factory ConnectionFlavorModel({
    required String tradingApi,
    required String tradingAuthApi,
    required String walletApi,
    required String validationApi,
  }) = _ConnectionFlavorModel;

  factory ConnectionFlavorModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFlavorModelFromJson(json);
}
