import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/shared/features/disclaimer/model/disclaimer_model.dart';

part 'disclaimers_response_model.freezed.dart';
part 'disclaimers_response_model.g.dart';

@freezed
class DisclaimersResponseModel with _$DisclaimersResponseModel {
  const factory DisclaimersResponseModel({
    List<DisclaimerModel>? disclaimers,
  }) = _DisclaimersResponseModel;

  factory DisclaimersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DisclaimersResponseModelFromJson(json);
}
