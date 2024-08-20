import 'package:freezed_annotation/freezed_annotation.dart';

part 'install_model.freezed.dart';
part 'install_model.g.dart';

@freezed
class InstallModel with _$InstallModel {
  factory InstallModel({
    String? installId,
    int? platform,
    String? deviceUid,
    String? version,
    String? lang,
    String? appsflyerId,
    String? idfa,
    String? idfv,
    String? adid,
    String? utmSource,
    String? campaign,
    String? mediaSource,
  }) = _InstallModel;

  factory InstallModel.fromJson(Map<String, dynamic> json) => _$InstallModelFromJson(json);
}
