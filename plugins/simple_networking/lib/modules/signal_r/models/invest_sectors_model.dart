import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'invest_sectors_model.freezed.dart';
part 'invest_sectors_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class InvestSectorsModel with _$InvestSectorsModel {
  const factory InvestSectorsModel({
    required List<InvestSectorModel> sectors,
  }) = _InvestSectorsModel;

  factory InvestSectorsModel.fromJson(Map<String, dynamic> json) =>
      _$InvestSectorsModelFromJson(json);
}

@freezed
class InvestSectorModel with _$InvestSectorModel {
  const factory InvestSectorModel({
    String? id,
    String? name,
    String? description,
  }) = _InvestSectorModel;

  factory InvestSectorModel.fromJson(Map<String, dynamic> json) =>
      _$InvestSectorModelFromJson(json);
}
