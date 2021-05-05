class Asset {
  Asset(
      {required this.symbol,
      required this.description,
      required this.accuracy});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      symbol: json['symbol'].toString(),
      description: json['description'].toString(),
      accuracy: num.parse(json['accuracy'].toString()),
    );
  }

  String symbol;
  String description;
  num accuracy;
}

class AssetListModel {
  AssetListModel({required this.assets, required this.now});

  factory AssetListModel.fromJson(Map<String, dynamic> json) {
    final assets = <Asset>[];
    json['assets'].forEach((e) => assets.add(Asset.fromJson(e)));

    return AssetListModel(
      assets: assets,
      now: int.parse(json['now'].toString()),
    );
  }

  List<Asset> assets;
  int now;
}

class Balance {
  Balance({
    required this.assetId,
    required this.balance,
    required this.reserve,
    required this.lastUpdate,
    required this.sequenceId,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      assetId: json['assetId'].toString(),
      balance: num.parse(json['balance'].toString()),
      reserve: num.parse(json['reserve'].toString()),
      lastUpdate: json['lastUpdate'].toString(),
      sequenceId: num.parse(json['sequenceId'].toString()),
    );
  }

  String assetId;
  num balance;
  num reserve;
  String lastUpdate;
  num sequenceId;
}

class BalanceListModel {
  BalanceListModel({required this.balances});

  factory BalanceListModel.fromJson(Map<String, dynamic> json) {
    final balances = <Balance>[];
    json['balances'].forEach((e) => balances.add(Balance.fromJson(e)));

    return BalanceListModel(
      balances: balances,
    );
  }

  List<Balance> balances;
}

class AssetBalance {
  AssetBalance({
    required this.description,
    required this.balance,
    required this.symbol,
    this.icon = 'http://cryptoicons.co/images/coin_icon@2x.png',
  });

  String icon;
  String description;
  num balance;
  String symbol;
}
