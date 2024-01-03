import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'simple_card_create_response.freezed.dart';
part 'simple_card_create_response.g.dart';

@freezed
class SimpleCardCreateResponse with _$SimpleCardCreateResponse {
  factory SimpleCardCreateResponse({
    final bool? simpleKycRequired,
    final bool? bankingKycRequired,
    final SimpleCardModel? card,
  }) = _SimpleCardCreateResponse;

  factory SimpleCardCreateResponse.fromJson(Map<String, dynamic> json) => _$SimpleCardCreateResponseFromJson(json);
}

@freezed
class SimpleCardModel with _$SimpleCardModel {
  factory SimpleCardModel({
    final String? cardId,
    final String? cardPan,
    final String? cardExpDate,
    final String? cardType,
    final String? currency,
    final String? nameOnCard,
    @AccountStatusCardSerialiser() AccountStatusCard? status,
    @DecimalSerialiser() Decimal? balance,
  }) = _SimpleCardModel;

  factory SimpleCardModel.fromJson(Map<String, dynamic> json) => _$SimpleCardModelFromJson(json);
}

enum AccountStatusCard { inCreation, active, frozen, inactive, unsupported }

extension _AccountStatusCardExtension on AccountStatusCard {
  String get name {
    switch (this) {
      case AccountStatusCard.inCreation:
        return 'inCreation';
      case AccountStatusCard.active:
        return 'active';
      case AccountStatusCard.frozen:
        return 'frozen';
      case AccountStatusCard.inactive:
        return 'inactive';
      default:
        return 'Unsupported';
    }
  }
}

class AccountStatusCardSerialiser implements JsonConverter<AccountStatusCard, dynamic> {
  const AccountStatusCardSerialiser();

  @override
  AccountStatusCard fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return AccountStatusCard.inCreation;
    } else if (value == '1') {
      return AccountStatusCard.active;
    } else if (value == '2') {
      return AccountStatusCard.frozen;
    } else if (value == '3') {
      return AccountStatusCard.inactive;
    } else {
      return AccountStatusCard.unsupported;
    }
  }

  @override
  dynamic toJson(AccountStatusCard type) => type.name;
}
