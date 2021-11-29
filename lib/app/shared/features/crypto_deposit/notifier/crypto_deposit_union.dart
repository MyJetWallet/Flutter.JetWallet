import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_deposit_union.freezed.dart';

@freezed
class CryptoDepositUnion with _$CryptoDepositUnion{
  const factory CryptoDepositUnion.success() = Success;
  const factory CryptoDepositUnion.loading() = Loading;
}
