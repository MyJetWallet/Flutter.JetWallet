import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/anchors/anchors_service.dart';
import 'package:jetwallet/core/services/anchors/models/convert_confirmation_model/convert_confirmation_model.dart';
import 'package:jetwallet/core/services/anchors/models/crypto_deposit/crypto_deposit_model.dart';
import 'package:simple_networking/modules/analytic_records/models/anchor_record.dart';

class AnchorsHelper {
  static const allAnchorTypes = [
    anchorTypeCryptoDeposit,
    anchorTypeConvertConfirmation,
    anchorTypeMarketDetails,
    anchorTypeBankingAccountDetails,
    anchorTypeForgotEarnDeposit,
    anchorTypeForgotTopUpEarnDeposit,
    anchorTypeForgotSectors,
    anchorTypeAddExternalIban,
  ];

  ///
  /// Metadata:
  ///
  static const anchorMetadataAssetSymbol = 'assetSymbol';

  static const anchorMetadataFromAsset = 'fromAsset';
  static const anchorMetadataToAsset = 'toAsset';
  static const anchorMetadataFromAmount = 'fromAmount';
  static const anchorMetadataToAmount = 'toAmount';
  static const anchorMetadataIsFromFixed = 'isFromFixed';

  static const anchorMetadataAccountId = 'accountId';

  static const anchorMetadataOfferId = 'offerId';
  static const anchorMetadataPositionId = 'positionId';

  static const anchorMetadataSectorId = 'sector_id';

  ///
  /// Name: Forgot to receive
  /// Crypto Deposit (screen [CryptoDeposit], model [CryptoDepositModel])
  ///
  static const anchorTypeCryptoDeposit = 'CryptoDeposit';

  AnchorRecordModel _cryptoDeposit(CryptoDepositModel model) => AnchorRecordModel(
        anchorType: anchorTypeCryptoDeposit,
        metadata: model.toJson(),
      );

  Future<void> addCryptoDepositAnchor(String assetSymbol) async {
    await getIt.get<AnchorsService>().setAnchor(
          _cryptoDeposit(
            CryptoDepositModel(
              assetSymbol: assetSymbol,
            ),
          ),
        );

    return;
  }

  ///
  /// Name: Forgot to exchange
  /// Convert Confirmation (screen [ConvertConfirmationScreen], model [ConvertConfirmationModel])
  ///
  static const anchorTypeConvertConfirmation = 'ConvertConfirmation';

  AnchorRecordModel _convertConfirmation(ConvertConfirmationModel model) => AnchorRecordModel(
        anchorType: anchorTypeConvertConfirmation,
        metadata: model.toJson(),
      );

  Future<void> addConvertConfirmAnchor({
    required String fromAsset,
    required String toAsset,
    required Decimal fromAmount,
    required Decimal toAmount,
    required bool isFromFixed,
  }) async {
    await getIt.get<AnchorsService>().setAnchor(
          _convertConfirmation(
            ConvertConfirmationModel(
              fromAsset: fromAsset,
              toAsset: toAsset,
              fromAmount: fromAmount,
              toAmount: toAmount,
              isFromFixed: isFromFixed,
            ),
          ),
        );

    return;
  }

  ///
  /// Name: Interesting to buy
  /// Market Details (screen [MarketDetails], model [CryptoDepositModel])
  ///
  static const anchorTypeMarketDetails = 'MarketDetails';

  AnchorRecordModel _marketDetails(CryptoDepositModel model) => AnchorRecordModel(
        anchorType: anchorTypeMarketDetails,
        metadata: model.toJson(),
      );

  Future<void> addMarketDetailsAnchor(String assetSymbol) async {
    await getIt.get<AnchorsService>().setAnchor(
          _marketDetails(
            CryptoDepositModel(
              assetSymbol: assetSymbol,
            ),
          ),
        );

    return;
  }

  ///
  /// Name: Forgot receive from IBAN
  /// Banking Account Details (screen [showAccountDetails]
  ///
  static const anchorTypeBankingAccountDetails = 'BankingAccountDetails';

  AnchorRecordModel _bankingAccountDetails(String accountId) => AnchorRecordModel(
        anchorType: anchorTypeBankingAccountDetails,
        metadata: {
          anchorMetadataAccountId: accountId,
        },
      );

  Future<void> addBankingAccountDetailsAnchor(String accountId) async {
    await getIt.get<AnchorsService>().setAnchor(_bankingAccountDetails(accountId));

    return;
  }

  ///
  /// Name: Forgot EARN
  /// Earn deposit (screen [EarnDeposit]
  ///
  static const anchorTypeForgotEarnDeposit = 'ForgotEarnDeposit';

  AnchorRecordModel _forgotEarnDepositDetails(String offerId) => AnchorRecordModel(
        anchorType: anchorTypeForgotEarnDeposit,
        metadata: {
          anchorMetadataOfferId: offerId,
        },
      );

  Future<void> addForgotEarnDepositAnchor(String offerId) async {
    await getIt.get<AnchorsService>().setAnchor(_forgotEarnDepositDetails(offerId));

    return;
  }

  ///
  /// Name: Forgot top up EARN
  /// Earn deposit (screen [EarnDeposit]
  ///
  static const anchorTypeForgotTopUpEarnDeposit = 'TopUpEarnDeposit';

  AnchorRecordModel _topUpEarnDepositDetails({required String offerId, required String positionId}) =>
      AnchorRecordModel(
        anchorType: anchorTypeForgotTopUpEarnDeposit,
        metadata: {
          anchorMetadataOfferId: offerId,
          anchorMetadataPositionId: positionId,
        },
      );

  Future<void> addTopUpEarnDepositAnchor({required String offerId, required String positionId}) async {
    await getIt.get<AnchorsService>().setAnchor(
          _topUpEarnDepositDetails(
            offerId: offerId,
            positionId: positionId,
          ),
        );

    return;
  }

  ///
  /// Name: Forgot Sectors
  /// Forgot sector (screen [MarketSectorDetailsScreen]
  ///
  static const anchorTypeForgotSectors = 'ForgotSectors';

  AnchorRecordModel _forgotSectors(String sectorId) => AnchorRecordModel(
        anchorType: anchorTypeForgotSectors,
        metadata: {
          anchorMetadataSectorId: sectorId,
        },
      );

  Future<void> addForgotSectorsAnchor(String sectorId) async {
    await getIt.get<AnchorsService>().setAnchor(_forgotSectors(sectorId));

    return;
  }

  ///
  /// Name: AddExternalIban
  /// Add External Iban (screen [MarketSectorDetailsScreen]
  ///
  static const anchorTypeAddExternalIban = 'AddExternalIban';

  AnchorRecordModel _addExternalIban(String accountId) => AnchorRecordModel(
        anchorType: anchorTypeAddExternalIban,
        metadata: {
          anchorMetadataAccountId: accountId,
        },
      );

  Future<void> addAddExternalIbanAnchor(String accountId) async {
    await getIt.get<AnchorsService>().setAnchor(_addExternalIban(accountId));

    return;
  }
}
