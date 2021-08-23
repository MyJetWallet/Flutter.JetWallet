import 'package:flutter_test/flutter_test.dart';
import 'package:jetwallet/app/shared/helpers/calculate_base_balance.dart';
import 'package:jetwallet/service/services/signal_r/model/prices_model.dart';
import 'package:jetwallet/service/services/wallet/model/asset_converter_map/asset_converter_map_model.dart';

void main() {
  group('Calculate base balance X -> X', () {
    test('EUR -> USD', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'EUR',
        assetBalance: 20000.0,
        prices: prices,
        converter: converter,
      );

      expect(result, 24323.09);
    });
    test('BTC -> USD', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'BTC',
        assetBalance: 25.0,
        prices: prices,
        converter: converter,
      );

      expect(result, 987421.0);
    });
    test('XLM -> EUR (Wrong order must be sorted)', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'XLM',
        assetBalance: 200.0,
        prices: prices,
        converter: converter,
      );

      expect(result, 4100.0);
    });
    test('XRP -> DOGE (High percision)', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 8,
        assetSymbol: 'XRP',
        assetBalance: 7583.92832261,
        prices: prices,
        converter: converter,
      );

      expect(result, 7591.57621784);
    });
  });

  group('Special cases', () {
    test('IF X -> X return assetBalance', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'USD',
        assetBalance: 53564.31,
        prices: prices,
        converter: converter,
      );

      expect(result, 53564.31);
    });
    test('Zero balance must be zero', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'BTC',
        assetBalance: 0.0,
        prices: prices,
        converter: converter,
      );

      expect(result, 0.0);
    });
    test('No maps available should return -1', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'LTC',
        assetBalance: 300.0,
        prices: prices,
        converter: converter,
      );

      expect(result, -1);
    });
    test('No prices available should return -1', () async {
      final result = calculateBaseBalanceWithMap(
        accuracy: 2,
        assetSymbol: 'EOS',
        assetBalance: 300.0,
        prices: prices,
        converter: converter,
      );

      expect(result, -1);
    });
  });
}

const prices = <PriceModel>[
  PriceModel(
    id: 'BTCEUR',
    date: 0.0,
    bid: 32243.38,
    ask: 32476.83,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
  PriceModel(
    id: 'BTCUSD',
    date: 0.0,
    bid: 39338.16,
    ask: 39496.84,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
  PriceModel(
    id: 'XRPTRX',
    date: 0.0,
    bid: 18.92329312,
    ask: 19.173,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
  PriceModel(
    id: 'TRXXLM',
    date: 0.0,
    bid: 2.971,
    ask: 3.28238,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
  PriceModel(
    id: 'XLMDOGE',
    date: 0.0,
    bid: 0.16173211,
    ask: 0.17328238,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
  PriceModel(
    id: 'XLMETH',
    date: 0.0,
    bid: 0.005,
    ask: 0.006,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
  PriceModel(
    id: 'ETHEUR',
    date: 0.0,
    bid: 4100.0,
    ask: 4115.0,
    dayPercentageChange: 0,
    dayPriceChange: 0,
    lastPrice: 0,
  ),
];

// ignore: prefer_const_constructors
AssetConverterMapModel converter = AssetConverterMapModel(
  baseAssetSymbol: 'USD',
  maps: [
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'BTC',
      operations: [
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 1,
          isMultiply: true,
          instrumentPair: 'BTCUSD',
          useBid: false,
        )
      ],
    ),
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'XRP',
      operations: [
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 1,
          isMultiply: false,
          instrumentPair: 'XRPTRX',
          useBid: true,
        ),
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 2,
          isMultiply: true,
          instrumentPair: 'TRXXLM',
          useBid: false,
        ),
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 3,
          isMultiply: false,
          instrumentPair: 'XLMDOGE',
          useBid: false,
        )
      ],
    ),
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'EUR',
      operations: [
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 1,
          isMultiply: false,
          instrumentPair: 'BTCEUR',
          useBid: false,
        ),
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 2,
          isMultiply: true,
          instrumentPair: 'BTCUSD',
          useBid: false,
        ),
      ],
    ),
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'XLM',
      operations: [
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 2,
          isMultiply: true,
          instrumentPair: 'XLMETH',
          useBid: true,
        ),
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 1,
          isMultiply: true,
          instrumentPair: 'ETHEUR',
          useBid: true,
        ),
      ],
    ),
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'USD',
      operations: [],
    ),
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'LTC',
      operations: [],
    ),
    // ignore: prefer_const_constructors
    AssetConverterMapItemModel(
      assetSymbol: 'EOS',
      operations: [
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 1,
          isMultiply: false,
          instrumentPair: 'EOSCAP',
          useBid: false,
        ),
        // ignore: prefer_const_constructors
        AssetConverterMapOperationModel(
          order: 2,
          isMultiply: true,
          instrumentPair: 'CAPHBAR',
          useBid: false,
        ),
      ],
    ),
  ],
);
