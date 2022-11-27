import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_code_link_union.freezed.dart';

@freezed
class ReferralCodeLinkUnion with _$ReferralCodeLinkUnion {
  const factory ReferralCodeLinkUnion.input() = Input;
  const factory ReferralCodeLinkUnion.hide() = Hide;
  const factory ReferralCodeLinkUnion.invalid() = Invalid;
  const factory ReferralCodeLinkUnion.loading() = Loading;
  const factory ReferralCodeLinkUnion.valid() = Valid;
}
