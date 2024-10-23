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
  /// Crypto Deposit (screen [ConvertConfirmationScreen], model [ConvertConfirmationModel])
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
  /// Crypto Deposit (screen [MarketDetails], model [CryptoDepositModel])
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
}
