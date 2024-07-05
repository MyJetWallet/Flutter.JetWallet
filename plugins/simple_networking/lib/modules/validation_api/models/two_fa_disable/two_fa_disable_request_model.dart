import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_disable_request_model.freezed.dart';
part 'two_fa_disable_request_model.g.dart';

@freezed
class TwoFaDisableRequestModel with _$TwoFaDisableRequestModel {
  const factory TwoFaDisableRequestModel({
    required String code,
  }) = _TwoFaDisableRequestModel;

  factory TwoFaDisableRequestModel.fromJson(Map<String, dynamic> json) => _$TwoFaDisableRequestModelFromJson(json);
}
