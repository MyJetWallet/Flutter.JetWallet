import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_promo_code_union.freezed.dart';

@freezed
class NftPromoCodeUnion with _$NftPromoCodeUnion {
  const factory NftPromoCodeUnion.input() = Input;
  const factory NftPromoCodeUnion.hide() = Hide;
  const factory NftPromoCodeUnion.invalid() = Invalid;
  const factory NftPromoCodeUnion.loading() = Loading;
  const factory NftPromoCodeUnion.valid() = Valid;
}
