import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/service/model/wallet/asset_model.dart';
import '../../../../service/services/signal_r/service/model/wallet/balance_model.dart';
import '../models/asset_with_balance_model.dart';
import 'assets_spod.dart';
import 'balances_spod.dart';

final assetsWithBalancesPod = Provider<List<AssetWithBalanceModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);

  var newAssets = <AssetModel>[];
  var newBalances = <BalanceModel>[];
  final assetsWithBalances = <AssetWithBalanceModel>[];

  assets.whenData((value) {
    newAssets = List.from(value.assets);
  });

  balances.whenData((value) {
    newBalances = List.from(value.balances);
  });

  if (newAssets.isNotEmpty) {
    for (final i in newAssets) {
      assetsWithBalances.add(
        AssetWithBalanceModel(
          // asset
          symbol: i.symbol,
          description: i.description,
          accuracy: i.accuracy,
          depositMode: i.depositMode,
          withdrawalMode: i.withdrawalMode,
          tagType: i.tagType,
          // balance
          assetId: 'unknown',
          balance: 0.0,
          reserve: 0.0,
          lastUpdate: 'unknown',
          sequenceId: 0.0,
        ),
      );
    }
  }

  if (newBalances.isNotEmpty) {
    for (final balance in newBalances) {
      for (final asset in assetsWithBalances) {
        if (asset.symbol == balance.assetId) {
          final index = assetsWithBalances.indexOf(asset);

          assetsWithBalances[index] = asset.copyWith(
            assetId: balance.assetId,
            balance: balance.balance,
            reserve: balance.reserve,
            lastUpdate: balance.lastUpdate,
            sequenceId: balance.sequenceId,
          );
        }
      }
    }
  }

  return assetsWithBalances;
});
