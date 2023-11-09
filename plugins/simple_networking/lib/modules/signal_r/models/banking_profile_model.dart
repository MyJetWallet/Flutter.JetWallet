import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

part 'banking_profile_model.freezed.dart';
part 'banking_profile_model.g.dart';

@freezed
class BankingProfileModel with _$BankingProfileModel {
  factory BankingProfileModel({
    final SimpleBankingModel? simple,
    final BankingDataModel? banking,
    @BankingShowStateSerialiser() final BankingShowState? showState,
  }) = _BankingProfileModel;

  factory BankingProfileModel.fromJson(Map<String, dynamic> json) => _$BankingProfileModelFromJson(json);
}

@freezed
class SimpleBankingModel with _$SimpleBankingModel {
  const factory SimpleBankingModel({
    @SimpleAccountStatusSerialiser() final SimpleAccountStatus? status,
    final SimpleBankingAccount? account,
  }) = _SimpleBankingModel;

  factory SimpleBankingModel.fromJson(Map<String, dynamic> json) => _$SimpleBankingModelFromJson(json);
}

@freezed
class SimpleBankingAccount with _$SimpleBankingAccount {
  const factory SimpleBankingAccount({
    final String? accountId,
    final String? iban,
    final String? currency,
    @DecimalNullSerialiser() final Decimal? balance,
    @AccountStatusSerialiser() final AccountStatus? status,
    final String? bic,
    final String? address,
    final String? bankName,
    final String? bankCountry,
    final String? holderFirstName,
    final String? holderLastName,
    final bool? isHidden,
    final String? label,
  }) = _SimpleBankingAccount;

  factory SimpleBankingAccount.fromJson(Map<String, dynamic> json) => _$SimpleBankingAccountFromJson(json);
}

@freezed
class CardDataModel with _$CardDataModel {
  const factory CardDataModel({
    final String? cardId,
    final String? cardNumberMasked,
    final String? currency,
    @DecimalNullSerialiser() final Decimal? balance,
    final AccountStatusCard? status,
    final String? nameOnCard,
    final String? cardType,
    final String? expiryDate,
    final bool? isHidden,
    final String? label,
    final bool? passwordIsSet,
  }) = _CardDataModel;

  factory CardDataModel.fromJson(Map<String, dynamic> json) => _$CardDataModelFromJson(json);
}

@freezed
class BankingDataModel with _$BankingDataModel {
  const factory BankingDataModel({
    @BankingClientStatusSerialiser() final BankingClientStatus? status,
    final List<SimpleBankingAccount>? accounts,
    final List<CardDataModel>? cards,
  }) = _BankingDataModel;

  factory BankingDataModel.fromJson(Map<String, dynamic> json) => _$BankingDataModelFromJson(json);
}

/// Enum

enum SimpleAccountStatus { kycRequired, kycInProgress, kycBlocked, addressRequired, allowed, unsupported }

extension _SimpleAccountStatusExtension on SimpleAccountStatus {
  String get name {
    switch (this) {
      case SimpleAccountStatus.kycRequired:
        return 'KycRequired';
      case SimpleAccountStatus.kycInProgress:
        return 'KycInProgress';
      case SimpleAccountStatus.kycBlocked:
        return 'KycBlocked';
      case SimpleAccountStatus.addressRequired:
        return 'AddressRequired';
      case SimpleAccountStatus.allowed:
        return 'Allowed';
      default:
        return 'Unsupported';
    }
  }
}

class SimpleAccountStatusSerialiser implements JsonConverter<SimpleAccountStatus, dynamic> {
  const SimpleAccountStatusSerialiser();

  @override
  SimpleAccountStatus fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return SimpleAccountStatus.kycRequired;
    } else if (value == '1') {
      return SimpleAccountStatus.kycInProgress;
    } else if (value == '2') {
      return SimpleAccountStatus.kycBlocked;
    } else if (value == '3') {
      return SimpleAccountStatus.addressRequired;
    } else if (value == '4') {
      return SimpleAccountStatus.allowed;
    } else {
      return SimpleAccountStatus.unsupported;
    }
  }

  @override
  dynamic toJson(SimpleAccountStatus type) => type.name;
}

///

enum AccountStatus { inCreation, active, frozen, inactive, unsupported }

extension _AccountStatusExtension on AccountStatus {
  String get name {
    switch (this) {
      case AccountStatus.inCreation:
        return 'InCreation';
      case AccountStatus.active:
        return 'Active';
      case AccountStatus.frozen:
        return 'Frozen';
      case AccountStatus.inactive:
        return 'Inactive';
      default:
        return 'Unsupported';
    }
  }
}

class AccountStatusSerialiser implements JsonConverter<AccountStatus, dynamic> {
  const AccountStatusSerialiser();

  @override
  AccountStatus fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return AccountStatus.inCreation;
    } else if (value == '1') {
      return AccountStatus.active;
    } else if (value == '2') {
      return AccountStatus.frozen;
    } else if (value == '3') {
      return AccountStatus.inactive;
    } else {
      return AccountStatus.unsupported;
    }
  }

  @override
  dynamic toJson(AccountStatus type) => type.name;
}

///

enum BankingClientStatus {
  notAllowed,
  suspended,
  kycBlocked,
  allowed,
  kycInProgress,
  simpleKycRequired,
  bankingKycRequired,
  unsupported,
}

extension _BankingClientStatusExtension on BankingClientStatus {
  String get name {
    switch (this) {
      case BankingClientStatus.notAllowed:
        return 'NotAllowed';
      case BankingClientStatus.suspended:
        return 'Suspended';
      case BankingClientStatus.kycBlocked:
        return 'KycBlocked';
      case BankingClientStatus.allowed:
        return 'Allowed';
      case BankingClientStatus.kycInProgress:
        return 'KycInProgress';
      case BankingClientStatus.simpleKycRequired:
        return 'SimpleKycRequired';
      case BankingClientStatus.bankingKycRequired:
        return 'BankingKycRequired';
      default:
        return 'Unsupported';
    }
  }
}

class BankingClientStatusSerialiser implements JsonConverter<BankingClientStatus, dynamic> {
  const BankingClientStatusSerialiser();

  @override
  BankingClientStatus fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return BankingClientStatus.notAllowed;
    } else if (value == '1') {
      return BankingClientStatus.suspended;
    } else if (value == '2') {
      return BankingClientStatus.kycBlocked;
    } else if (value == '3') {
      return BankingClientStatus.allowed;
    } else if (value == '4') {
      return BankingClientStatus.kycInProgress;
    } else if (value == '5') {
      return BankingClientStatus.simpleKycRequired;
    } else if (value == '6') {
      return BankingClientStatus.bankingKycRequired;
    } else {
      return BankingClientStatus.unsupported;
    }
  }

  @override
  dynamic toJson(BankingClientStatus type) => type.name;
}

///

enum BankingShowState {
  hide,
  accountList,
  onlySimple,
  getAccount,
  inProgress,
  getAccountBlock,
  unsupported,
}

extension _BankingShowStateExtension on BankingShowState {
  String get name {
    switch (this) {
      case BankingShowState.hide:
        return 'Hide';
      case BankingShowState.accountList:
        return 'AccountList';
      case BankingShowState.onlySimple:
        return 'OnlySimple';
      case BankingShowState.getAccount:
        return 'GetAccount';
      case BankingShowState.inProgress:
        return 'InProgress';
      case BankingShowState.getAccountBlock:
        return 'GetAccountBlock';
      default:
        return 'Unsupported';
    }
  }
}

class BankingShowStateSerialiser implements JsonConverter<BankingShowState, dynamic> {
  const BankingShowStateSerialiser();

  @override
  BankingShowState fromJson(dynamic json) {
    final value = json.toString();

    if (value == '0') {
      return BankingShowState.hide;
    } else if (value == '1') {
      return BankingShowState.accountList;
    } else if (value == '2') {
      return BankingShowState.onlySimple;
    } else if (value == '3') {
      return BankingShowState.getAccount;
    } else if (value == '4') {
      return BankingShowState.inProgress;
    } else if (value == '5') {
      return BankingShowState.getAccountBlock;
    } else {
      return BankingShowState.unsupported;
    }
  }

  @override
  dynamic toJson(BankingShowState type) => type.name;
}
