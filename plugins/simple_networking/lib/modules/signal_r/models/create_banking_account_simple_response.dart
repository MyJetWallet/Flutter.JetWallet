import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_banking_account_simple_response.freezed.dart';
part 'create_banking_account_simple_response.g.dart';

@freezed
class CreateBankingAccountSimpleResponse with _$CreateBankingAccountSimpleResponse {
  factory CreateBankingAccountSimpleResponse({
    @Default(false) final bool simpleKycRequired,
    @Default(false) final bool bankingKycRequired,
    @Default(false) final bool addressSetupRequired,
  }) = _CreateBankingAccountSimpleResponse;

  factory CreateBankingAccountSimpleResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateBankingAccountSimpleResponseFromJson(json);
}
