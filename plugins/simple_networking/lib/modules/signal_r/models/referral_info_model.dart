import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_info_model.freezed.dart';
part 'referral_info_model.g.dart';

@freezed
class ReferralInfoModel with _$ReferralInfoModel {
  const factory ReferralInfoModel({
    required String referralCode,
    required List<String> referralTerms,
    required String referralLink,
    required String title,
    required String descriptionLink,
    String? nftPromoCode,
  }) = _ReferralInfoModel;

  factory ReferralInfoModel.fromJson(Map<String, dynamic> json) => _$ReferralInfoModelFromJson(json);
}
